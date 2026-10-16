import { onCall, HttpsError } from "firebase-functions/v2/https";
import { db, FieldValue } from "../shared/admin";
import { requireUid, requireString, assertSafeId } from "../shared/validation";
import { success } from "../shared/response";

export const setRecipeSaved = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const recipeId = assertSafeId(requireString(request.data?.recipeId, "recipeId", 128), "recipeId");
  const shouldSave = request.data?.saved !== false;
  const recipeRef = db.collection("recipes").doc(recipeId);
  const recipe = await recipeRef.get();
  if (!recipe.exists || (recipe.data()?.visibility !== "public" && recipe.data()?.createdBy !== uid)) {
    throw new HttpsError("not-found", "Recipe was not found.");
  }
  const savedRef = db.collection("users").doc(uid).collection("saved_recipes").doc(recipeId);
  if (shouldSave) {
    await savedRef.set({ recipeId, savedAt: FieldValue.serverTimestamp() }, { merge: true });
  } else {
    await savedRef.delete();
  }
  return success({ recipeId, saved: shouldSave }, recipeId);
});

export const getSavedRecipes = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const pageSize = Math.min(Math.max(Number(request.data?.pageSize ?? 20), 1), 50);
  const saved = await db.collection("users").doc(uid).collection("saved_recipes")
    .orderBy("savedAt", "desc").limit(pageSize).get();
  const recipes = await Promise.all(saved.docs.map(async (doc) => {
    const recipe = await db.collection("recipes").doc(doc.id).get();
    return recipe.exists ? { id: recipe.id, ...recipe.data() } : null;
  }));
  return success({ recipes: recipes.filter((recipe) => recipe !== null) }, uid);
});

export const getMealAnalysisHistory = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const pageSize = Math.min(Math.max(Number(request.data?.pageSize ?? 20), 1), 50);
  const snapshot = await db.collection("users").doc(uid).collection("meal_analyses")
    .orderBy("createdAt", "desc").limit(pageSize).get();
  return success({
    analyses: snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() })),
    hasMore: snapshot.size === pageSize,
  }, uid);
});

export const getCoachConversationHistory = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const conversationId = assertSafeId(requireString(request.data?.conversationId, "conversationId", 128), "conversationId");
  const pageSize = Math.min(Math.max(Number(request.data?.pageSize ?? 30), 1), 100);
  const ref = db.collection("users").doc(uid).collection("coach_conversations").doc(conversationId);
  const conversation = await ref.get();
  if (!conversation.exists) throw new HttpsError("not-found", "Conversation was not found.");
  const messages = await ref.collection("messages").orderBy("createdAt", "asc").limit(pageSize).get();
  return success({
    conversation: { id: conversation.id, ...conversation.data() },
    messages: messages.docs.map((doc) => ({ id: doc.id, ...doc.data() })),
    hasMore: messages.size === pageSize,
  }, conversationId);
});

export const getProgressSummary = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const snapshot = await db.collection("users").doc(uid).collection("progress_entries")
    .orderBy("recordedAt", "asc").limit(500).get();
  const entries = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
  const withWeight = entries.filter((entry) => typeof entry.weightKg === "number");
  const withBodyFat = entries.filter((entry) => typeof entry.bodyFatPercentage === "number");
  const firstWeight = withWeight[0]?.weightKg;
  const lastWeight = withWeight[withWeight.length - 1]?.weightKg;
  const firstFat = withBodyFat[0]?.bodyFatPercentage;
  const lastFat = withBodyFat[withBodyFat.length - 1]?.bodyFatPercentage;
  return success({
    totalEntries: entries.length,
    currentWeightKg: lastWeight ?? null,
    startingWeightKg: firstWeight ?? null,
    weightChangeKg: typeof firstWeight === "number" && typeof lastWeight === "number" ? lastWeight - firstWeight : null,
    currentBodyFatPercentage: lastFat ?? null,
    startingBodyFatPercentage: firstFat ?? null,
    bodyFatChangePercentage: typeof firstFat === "number" && typeof lastFat === "number" ? lastFat - firstFat : null,
    firstRecordedAt: entries[0]?.recordedAt ?? null,
    lastRecordedAt: entries[entries.length - 1]?.recordedAt ?? null,
  }, uid);
});

export const updateProfilePhotoPath = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const path = requireString(request.data?.profilePhotoPath, "profilePhotoPath", 500);
  if (!path.startsWith("users/" + uid + "/profile/") || path.includes("..")) {
    throw new HttpsError("permission-denied", "Profile image path must belong to the current user.");
  }
  await db.collection("users").doc(uid).set({
    profilePhotoPath: path,
    updatedAt: FieldValue.serverTimestamp(),
  }, { merge: true });
  return success({ profilePhotoPath: path }, uid);
});