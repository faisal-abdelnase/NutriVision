import { onCall, HttpsError } from "firebase-functions/v2/https";
import { AI_API_KEY, askAI, parseJsonObject } from "../shared/ai";
import { db, FieldValue, bucket } from "../shared/admin";
import { enforceRateLimit } from "../shared/rate_limit";
import { requireUid, requireString, requireStringArray, assertSafeId } from "../shared/validation";
import { success } from "../shared/response";

const mealAnalysisPrompt = [
  "You are a food logging assistant, not a medical professional.",
  "Analyze the meal and return a JSON object only.",
  "Use keys identifiedFoods (array of name, quantity, unit, calories, proteinGrams, carbohydrateGrams, fatGrams),",
  "nutritionEstimate (calories, proteinGrams, carbohydrateGrams, fatGrams), warnings (array of strings), confidence (number from 0 to 1), and isEstimate (boolean).",
  "Nutrition values are estimates unless grounded in a verified nutrition database.",
  "Do not claim certainty about exact quantities from an image. If uncertain, explain it in warnings.",
].join(" ");

export const analyzeMeal = onCall({ secrets: [AI_API_KEY], timeoutSeconds: 120, memory: "512MiB" }, async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  await enforceRateLimit(uid, "meal_analysis", 10, 3600);
  const description = typeof request.data?.description === "string"
    ? request.data.description.trim().slice(0, 3000)
    : "";
  const imagePath = typeof request.data?.imagePath === "string"
    ? request.data.imagePath
    : undefined;
  if (!description && !imagePath) throw new HttpsError("invalid-argument", "Provide a meal description or imagePath.");
  let prompt = mealAnalysisPrompt + "\nMeal description: " + (description || "No text description provided.");
  if (imagePath) {
    const expectedPrefix = "users/" + uid + "/meal_images/";
    if (!imagePath.startsWith(expectedPrefix) || imagePath.includes("..")) {
      throw new HttpsError("permission-denied", "Image must belong to the current user.");
    }
    const [url] = await bucket.file(imagePath).getSignedUrl({
      action: "read",
      expires: Date.now() + 5 * 60 * 1000,
    });
    const apiKey = AI_API_KEY.value();
    if (!apiKey) throw new HttpsError("failed-precondition", "AI provider is not configured.");
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: { Authorization: "Bearer " + apiKey, "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "gpt-4o-mini",
        response_format: { type: "json_object" },
        max_tokens: 1200,
        messages: [
          { role: "system", content: mealAnalysisPrompt },
          { role: "user", content: [
            { type: "text", text: prompt },
            { type: "image_url", image_url: { url } },
          ] },
        ],
      }),
      signal: AbortSignal.timeout(60000),
    });
    if (!response.ok) {
      if (response.status === 429) throw new HttpsError("resource-exhausted", "AI provider rate limit reached.");
      throw new HttpsError("unavailable", "Meal image analysis failed.");
    }
    const payload = await response.json() as { choices?: Array<{ message?: { content?: string } }> };
    const content = payload.choices?.[0]?.message?.content;
    if (!content) throw new HttpsError("data-loss", "AI returned an empty response.");
    const parsed = parseJsonObject(content);
    const ref = db.collection("users").doc(uid).collection("meal_analyses").doc();
    await ref.set({
      id: ref.id, status: "completed", inputType: "image", inputText: description || null,
      imagePath, identifiedFoods: Array.isArray(parsed.identifiedFoods) ? parsed.identifiedFoods : [],
      nutritionEstimate: parsed.nutritionEstimate ?? {}, warnings: Array.isArray(parsed.warnings) ? parsed.warnings : [],
      confidence: typeof parsed.confidence === "number" ? Math.min(1, Math.max(0, parsed.confidence)) : null,
      isEstimate: true, provider: "openai", modelVersion: "gpt-4o-mini",
      promptVersion: "meal_analysis_v1", createdAt: FieldValue.serverTimestamp(),
      completedAt: FieldValue.serverTimestamp(),
    });
    return success({ analysisId: ref.id, ...parsed, isEstimate: true }, ref.id);
  }

  const result = parseJsonObject(await askAI([
    { role: "system", content: mealAnalysisPrompt },
    { role: "user", content: prompt },
  ], { json: true, maxTokens: 1200 }));
  const ref = db.collection("users").doc(uid).collection("meal_analyses").doc();
  await ref.set({
    id: ref.id, status: "completed", inputType: "text", inputText: description,
    identifiedFoods: Array.isArray(result.identifiedFoods) ? result.identifiedFoods : [],
    nutritionEstimate: result.nutritionEstimate ?? {}, warnings: Array.isArray(result.warnings) ? result.warnings : [],
    confidence: typeof result.confidence === "number" ? Math.min(1, Math.max(0, result.confidence)) : null,
    isEstimate: true, provider: "openai", modelVersion: "gpt-4o-mini",
    promptVersion: "meal_analysis_v1", createdAt: FieldValue.serverTimestamp(),
    completedAt: FieldValue.serverTimestamp(),
  });
  return success({ analysisId: ref.id, ...result, isEstimate: true }, ref.id);
});

export const sendCoachMessage = onCall({ secrets: [AI_API_KEY], timeoutSeconds: 90 }, async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  await enforceRateLimit(uid, "coach_message", 20, 3600);
  const message = requireString(request.data?.message, "message", 4000);
  const conversationId = typeof request.data?.conversationId === "string"
    ? assertSafeId(request.data.conversationId, "conversationId")
    : db.collection("_ids").doc().id;
  const conversationRef = db.collection("users").doc(uid).collection("coach_conversations").doc(conversationId);
  const [profile, recentMeals, recentMessages] = await Promise.all([
    db.collection("users").doc(uid).collection("nutrition_profile").doc("current").get(),
    db.collection("users").doc(uid).collection("meals").orderBy("consumedAt", "desc").limit(5).get(),
    conversationRef.collection("messages").orderBy("createdAt", "desc").limit(8).get(),
  ]);
  const profileData = profile.data() ?? {};
  const context = {
    goal: profileData.goal ?? "healthy_eating",
    dietaryPreferences: profileData.dietaryPreferences ?? [],
    allergies: profileData.allergies ?? [],
    recentMeals: recentMeals.docs.map((doc) => {
      const data = doc.data();
      return { mealName: data.mealName, consumedAt: data.consumedAt?.toDate?.().toISOString?.(), nutrition: data.nutrition };
    }),
  };
  const history = recentMessages.docs.reverse().map((doc) => {
    const data = doc.data();
    return { role: data.role === "assistant" ? "assistant" as const : "user" as const, content: String(data.content ?? "").slice(0, 4000) };
  });
  const answer = await askAI([
    {
      role: "system",
      content: "You are NutriVision's general nutrition wellness assistant. Be practical and supportive. Do not diagnose or prescribe treatment. Explain uncertainty, encourage professional care for medical concerns, and never assure that an ingredient is safe for an allergy. Use only relevant user context: " + JSON.stringify(context),
    },
    ...history,
    { role: "user", content: message },
  ], { maxTokens: 1000 });
  const now = FieldValue.serverTimestamp();
  const userMessageRef = conversationRef.collection("messages").doc();
  const assistantMessageRef = conversationRef.collection("messages").doc();
  const batch = db.batch();
  batch.set(conversationRef, {
    id: conversationId, userId: uid, title: message.slice(0, 80),
    updatedAt: now, lastMessagePreview: answer.slice(0, 160), isArchived: false,
  }, { merge: true });
  batch.set(userMessageRef, { id: userMessageRef.id, role: "user", content: message, createdAt: now });
  batch.set(assistantMessageRef, {
    id: assistantMessageRef.id, role: "assistant", content: answer, createdAt: now,
    provider: "openai", modelVersion: "gpt-4o-mini", promptVersion: "nutrition_coach_v1",
  });
  await batch.commit();
  return success({ conversationId, userMessageId: userMessageRef.id, messageId: assistantMessageRef.id, answer }, assistantMessageRef.id);
});

export const generateRecipe = onCall({ secrets: [AI_API_KEY], timeoutSeconds: 90 }, async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  await enforceRateLimit(uid, "recipe_generation", 10, 3600);
  const ingredients = requireStringArray(request.data?.availableIngredients ?? [], "availableIngredients", 40);
  const dietaryPreferences = requireStringArray(request.data?.dietaryPreferences ?? [], "dietaryPreferences", 30);
  const allergies = requireStringArray(request.data?.allergies ?? [], "allergies", 30);
  const excludedIngredients = requireStringArray(request.data?.excludedIngredients ?? [], "excludedIngredients", 50);
  if (ingredients.length === 0) throw new HttpsError("invalid-argument", "Provide at least one available ingredient.");
  const servings = Math.min(12, Math.max(1, Number(request.data?.servings ?? 2)));
  const result = parseJsonObject(await askAI([
    {
      role: "system",
      content: "Generate a practical recipe. Return JSON only with title, description, ingredients (array of name, quantity, unit), instructions (array of strings), preparationMinutes, cookingMinutes, servings, nutritionPerServing (calories, proteinGrams, carbohydrateGrams, fatGrams), tags, and warnings. Respect allergies and excluded ingredients; if a risk cannot be resolved, add a warning and do not claim allergen-free certainty. Nutrition is an estimate.",
    },
    {
      role: "user",
      content: JSON.stringify({ availableIngredients: ingredients, dietaryPreferences, allergies, excludedIngredients, servings }),
    },
  ], { json: true, maxTokens: 1400 }));
  const ref = db.collection("recipes").doc();
  const data = {
    id: ref.id, ...result, createdBy: uid, visibility: "private",
    isAiGenerated: true, isNutritionEstimate: true, promptVersion: "recipe_generation_v1",
    createdAt: FieldValue.serverTimestamp(), updatedAt: FieldValue.serverTimestamp(),
  };
  await ref.set(data);
  await db.collection("users").doc(uid).collection("saved_recipes").doc(ref.id).set({
    recipeId: ref.id, savedAt: FieldValue.serverTimestamp(),
  });
  return success({ recipeId: ref.id, recipe: data }, ref.id);
});

export const saveGroceryItem = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const input = request.data?.item;
  if (!input || typeof input !== "object" || Array.isArray(input)) throw new HttpsError("invalid-argument", "item is required.");
  const name = requireString(input.name, "name", 160);
  const id = typeof input.id === "string" ? assertSafeId(input.id, "item.id") : db.collection("_ids").doc().id;
  const quantity = Number(input.quantity ?? 1);
  if (!Number.isFinite(quantity) || quantity <= 0 || quantity > 100000) throw new HttpsError("invalid-argument", "quantity is invalid.");
  await db.collection("users").doc(uid).collection("grocery_items").doc(id).set({
    id, name, quantity, unit: typeof input.unit === "string" ? input.unit.slice(0, 24) : "item",
    isChecked: input.isChecked === true,
    category: typeof input.category === "string" ? input.category.slice(0, 80) : "other",
    recipeId: typeof input.recipeId === "string" ? input.recipeId.slice(0, 128) : null,
    updatedAt: FieldValue.serverTimestamp(),
    ...(input.id ? {} : { createdAt: FieldValue.serverTimestamp() }),
  }, { merge: true });
  return success({ itemId: id }, id);
});

export const deleteGroceryItem = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const id = assertSafeId(requireString(request.data?.itemId, "itemId", 128), "itemId");
  await db.collection("users").doc(uid).collection("grocery_items").doc(id).delete();
  return success({ deleted: true }, id);
});