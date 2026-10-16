import { HttpsError } from "firebase-functions/v2/https";

export function requireString(
  value: unknown,
  name: string,
  maxLength = 2000,
): string {
  if (typeof value !== "string" || value.trim().length === 0 || value.length > maxLength) {
    throw new HttpsError("invalid-argument", name + " is invalid.");
  }
  return value.trim();
}

export function optionalString(
  value: unknown,
  name: string,
  maxLength = 2000,
): string | undefined {
  if (value == null || value === "") return undefined;
  return requireString(value, name, maxLength);
}

export function requireUid(authUid: string | undefined, requestedUid?: unknown): string {
  if (!authUid) throw new HttpsError("unauthenticated", "Sign in is required.");
  if (requestedUid !== undefined && requestedUid !== authUid) {
    throw new HttpsError("permission-denied", "You cannot access another user's data.");
  }
  return authUid;
}

export function requireFiniteNumber(
  value: unknown,
  name: string,
  min = 0,
  max = 100000,
): number {
  if (typeof value !== "number" || !Number.isFinite(value) || value < min || value > max) {
    throw new HttpsError("invalid-argument", name + " is invalid.");
  }
  return value;
}

export function requireStringArray(
  value: unknown,
  name: string,
  maxItems = 50,
): string[] {
  if (!Array.isArray(value) || value.length > maxItems ||
      !value.every((item) => typeof item === "string" && item.length <= 200)) {
    throw new HttpsError("invalid-argument", name + " is invalid.");
  }
  return value.map((item: string) => item.trim()).filter(Boolean);
}

export function assertSafeId(value: string, name: string): string {
  if (!/^[A-Za-z0-9_-]{1,128}$/.test(value)) {
    throw new HttpsError("invalid-argument", name + " is invalid.");
  }
  return value;
}