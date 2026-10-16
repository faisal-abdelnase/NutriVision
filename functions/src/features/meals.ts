import { onCall, HttpsError } from "firebase-functions/v2/https";
import { db, FieldValue, Timestamp, bucket } from "../shared/admin";
import { requireUid, requireString, requireFiniteNumber, assertSafeId } from "../shared/validation";
import { success } from "../shared/response";

function dateFrom(value: unknown, name: string): Timestamp {
  if (typeof value !== "string" && typeof value !== "number") {
    throw new HttpsError("invalid-argument", name + " must be an ISO date or milliseconds.");
  }
  const date = new Date(value);
  if (!Number.isFinite(date.getTime())) throw new HttpsError("invalid-argument", name + " is invalid.");
  return Timestamp.fromDate(date);
}

export const saveMeal = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const input = request.data?.meal;
  if (!input || typeof input !== "object" || Array.isArray(input)) {
    throw new HttpsError("invalid-argument", "meal is required.");
  }
  const id = typeof input.id === "string" ? assertSafeId(input.id, "meal.id") : db.collection("_ids").doc().id;
  const mealName = requireString(input.mealName, "mealName", 160);
  const mealType = requireString(input.mealType, "mealType", 40);
  if (!["breakfast", "lunch", "dinner", "snack", "other"].includes(mealType)) {
    throw new HttpsError("invalid-argument", "Unsupported mealType.");
  }
  const foods = input.foods;
  if (!Array.isArray(foods) || foods.length > 100) throw new HttpsError("invalid-argument", "foods must be a list of at most 100 items.");
  const normalizedFoods = foods.map((food: Record<string, unknown>, index: number) => {
    if (!food || typeof food !== "object" || Array.isArray(food)) throw new HttpsError("invalid-argument", "Invalid food at index " + index);
    return {
      name: requireString(food.name, "foods.name", 160),
      quantity: requireFiniteNumber(food.quantity, "foods.quantity", 0, 100000),
      unit: requireString(food.unit, "foods.unit", 24),
      calories: requireFiniteNumber(food.calories ?? 0, "foods.calories", 0, 1000000),
      proteinGrams: requireFiniteNumber(food.proteinGrams ?? 0, "foods.proteinGrams", 0, 100000),
      carbohydrateGrams: requireFiniteNumber(food.carbohydrateGrams ?? 0, "foods.carbohydrateGrams", 0, 100000),
      fatGrams: requireFiniteNumber(food.fatGrams ?? 0, "foods.fatGrams", 0, 100000),
      ...(typeof food.foodId === "string" ? { foodId: food.foodId.slice(0, 128) } : {}),
    };
  });
  const nutritionInput = input.nutrition ?? {};
  if (typeof nutritionInput !== "object" || Array.isArray(nutritionInput)) throw new HttpsError("invalid-argument", "nutrition must be an object.");
  const nutrition = {
    calories: normalizedFoods.reduce((sum, food) => sum + food.calories, 0),
    proteinGrams: normalizedFoods.reduce((sum, food) => sum + food.proteinGrams, 0),
    carbohydrateGrams: normalizedFoods.reduce((sum, food) => sum + food.carbohydrateGrams, 0),
    fatGrams: normalizedFoods.reduce((sum, food) => sum + food.fatGrams, 0),
  };
  const consumedAt = dateFrom(input.consumedAt ?? Date.now(), "consumedAt");
  if (typeof input.imagePath === "string" &&
      (!input.imagePath.startsWith("users/" + uid + "/meal_images/") || input.imagePath.includes(".."))) {
    throw new HttpsError("permission-denied", "Meal image must belong to the current user.");
  }
  const ref = db.collection("users").doc(uid).collection("meals").doc(id);
  const existing = await ref.get();
  const data: Record<string, unknown> = {
    id, mealName, mealType,
    description: typeof input.description === "string" ? input.description.slice(0, 2000) : "",
    imagePath: typeof input.imagePath === "string" ? input.imagePath.slice(0, 500) : null,
    consumedAt,
    servings: requireFiniteNumber(input.servings ?? 1, "servings", 0.1, 100),
    foods: normalizedFoods,
    nutrition,
    source: input.source === "ai_analysis" ? "ai_analysis" : "manual",
    updatedAt: FieldValue.serverTimestamp(),
  };
  if (!existing.exists) data.createdAt = FieldValue.serverTimestamp();
  await ref.set(data, { merge: true });
  return success({ mealId: id, nutrition }, id);
});

export const deleteMeal = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const mealId = assertSafeId(requireString(request.data?.mealId, "mealId", 128), "mealId");
  const ref = db.collection("users").doc(uid).collection("meals").doc(mealId);
  const snapshot = await ref.get();
  const imagePath = snapshot.data()?.imagePath;
  await ref.delete();
  if (typeof imagePath === "string" && imagePath.startsWith("users/" + uid + "/meal_images/")) {
    await bucket.file(imagePath).delete({ ignoreNotFound: true }).catch(() => undefined);
  }
  return success({ deleted: true }, mealId);
});

export const getDashboardSummary = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const day = request.data?.date ? new Date(request.data.date) : new Date();
  if (!Number.isFinite(day.getTime())) throw new HttpsError("invalid-argument", "date is invalid.");
  const start = new Date(day.getFullYear(), day.getMonth(), day.getDate());
  const end = new Date(start.getTime() + 24 * 60 * 60 * 1000);
  const meals = await db.collection("users").doc(uid).collection("meals")
    .where("consumedAt", ">=", Timestamp.fromDate(start))
    .where("consumedAt", "<", Timestamp.fromDate(end))
    .orderBy("consumedAt", "desc").limit(100).get();
  const totals = { calories: 0, proteinGrams: 0, carbohydrateGrams: 0, fatGrams: 0 };
  const mealItems = meals.docs.map((doc) => {
    const data = doc.data();
    const nutrition = data.nutrition ?? {};
    totals.calories += Number(nutrition.calories ?? 0);
    totals.proteinGrams += Number(nutrition.proteinGrams ?? 0);
    totals.carbohydrateGrams += Number(nutrition.carbohydrateGrams ?? 0);
    totals.fatGrams += Number(nutrition.fatGrams ?? 0);
    return { id: doc.id, mealName: data.mealName, mealType: data.mealType, consumedAt: data.consumedAt, nutrition };
  });
  const profileSnap = await db.collection("users").doc(uid).collection("nutrition_profile").doc("current").get();
  const targets = profileSnap.data() ?? {};
  return success({
    date: start.toISOString(),
    totals,
    targets: {
      calories: targets.calorieTarget ?? null,
      proteinGrams: targets.proteinTargetGrams ?? null,
      carbohydrateGrams: targets.carbohydrateTargetGrams ?? null,
      fatGrams: targets.fatTargetGrams ?? null,
    },
    meals: mealItems,
  }, uid);
});