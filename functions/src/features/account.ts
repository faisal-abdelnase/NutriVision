import { onCall, HttpsError } from "firebase-functions/v2/https";
import { db, FieldValue } from "../shared/admin";
import { requireUid, requireString, optionalString, requireStringArray } from "../shared/validation";
import { success } from "../shared/response";

export const bootstrapUser = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid);
  const email = request.auth?.token.email;
  if (typeof email !== "string") {
    throw new HttpsError("failed-precondition", "A valid email account is required.");
  }
  const fullName = optionalString(request.data?.fullName, "fullName", 120);
  const userRef = db.collection("users").doc(uid);
  await db.runTransaction(async (tx) => {
    const snap = await tx.get(userRef);
    if (!snap.exists) {
      tx.set(userRef, {
        uid,
        email,
        fullName: fullName ?? "",
        preferredLanguage: "en",
        preferredTheme: "system",
        notificationsEnabled: true,
        onboardingCompleted: false,
        emailVerified: request.auth?.token.email_verified === true,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });
    } else {
      tx.set(userRef, {
        email,
        emailVerified: request.auth?.token.email_verified === true,
        updatedAt: FieldValue.serverTimestamp(),
      }, { merge: true });
    }
  });
  return success({ uid }, request.rawRequest.headers["x-request-id"]?.toString() ?? uid);
});

export const completeOnboarding = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid);
  const goal = requireString(request.data?.goal, "goal", 50);
  const dietaryPreferences = requireStringArray(request.data?.dietaryPreferences ?? [], "dietaryPreferences");
  const allergies = requireStringArray(request.data?.allergies ?? [], "allergies");
  const excludedIngredients = requireStringArray(request.data?.excludedIngredients ?? [], "excludedIngredients");
  const allowedGoals = ["lose_weight", "maintain_weight", "gain_weight", "healthy_eating"];
  if (!allowedGoals.includes(goal)) throw new HttpsError("invalid-argument", "Unsupported goal.");
  const batch = db.batch();
  batch.set(db.collection("users").doc(uid), {
    onboardingCompleted: true,
    updatedAt: FieldValue.serverTimestamp(),
  }, { merge: true });
  batch.set(db.collection("users").doc(uid).collection("nutrition_profile").doc("current"), {
    goal,
    dietaryPreferences,
    allergies,
    excludedIngredients,
    updatedAt: FieldValue.serverTimestamp(),
  }, { merge: true });
  await batch.commit();
  return success({ completed: true }, uid);
});

export const updateNutritionProfile = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const input = request.data?.profile;
  if (!input || typeof input !== "object" || Array.isArray(input)) {
    throw new HttpsError("invalid-argument", "profile is required.");
  }
  const allowed = [
    "goal", "dietaryPreferences", "allergies", "excludedIngredients",
    "activityLevel", "heightCm", "currentWeightKg", "targetWeightKg",
    "dateOfBirth", "units", "calorieTarget", "proteinTargetGrams",
    "carbohydrateTargetGrams", "fatTargetGrams",
  ];
  const patch: Record<string, unknown> = {};
  for (const key of allowed) {
    if (Object.prototype.hasOwnProperty.call(input, key)) patch[key] = input[key];
  }
  for (const key of ["dietaryPreferences", "allergies", "excludedIngredients"]) {
    if (key in patch) patch[key] = requireStringArray(patch[key], key);
  }
  if ("goal" in patch && !["lose_weight", "maintain_weight", "gain_weight", "healthy_eating"].includes(String(patch.goal))) {
    throw new HttpsError("invalid-argument", "Unsupported nutrition goal.");
  }
  patch.updatedAt = FieldValue.serverTimestamp();
  await db.collection("users").doc(uid).collection("nutrition_profile").doc("current").set(patch, { merge: true });
  return success({ updated: true }, uid);
});

export const updateUserPreferences = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const input = request.data?.preferences;
  if (!input || typeof input !== "object" || Array.isArray(input)) {
    throw new HttpsError("invalid-argument", "preferences is required.");
  }
  const patch: Record<string, unknown> = {};
  if (input.fullName !== undefined) patch.fullName = requireString(input.fullName, "fullName", 120);
  if (input.phoneNumber !== undefined) patch.phoneNumber = optionalString(input.phoneNumber, "phoneNumber", 40) ?? null;
  if (input.bio !== undefined) patch.bio = optionalString(input.bio, "bio", 500) ?? null;
  if (input.preferredLanguage !== undefined) {
    if (!["ar", "en"].includes(input.preferredLanguage)) throw new HttpsError("invalid-argument", "Unsupported language.");
    patch.preferredLanguage = input.preferredLanguage;
  }
  if (input.preferredTheme !== undefined) {
    if (!["light", "dark", "system"].includes(input.preferredTheme)) throw new HttpsError("invalid-argument", "Unsupported theme.");
    patch.preferredTheme = input.preferredTheme;
  }
  if (input.notificationsEnabled !== undefined) {
    if (typeof input.notificationsEnabled !== "boolean") throw new HttpsError("invalid-argument", "notificationsEnabled must be boolean.");
    patch.notificationsEnabled = input.notificationsEnabled;
  }
  patch.updatedAt = FieldValue.serverTimestamp();
  await db.collection("users").doc(uid).set(patch, { merge: true });
  return success({ updated: true }, uid);
});