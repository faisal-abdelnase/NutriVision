import { onCall, HttpsError } from "firebase-functions/v2/https";
import { db, FieldValue, Timestamp } from "../shared/admin";
import { requireUid, requireString, requireFiniteNumber, assertSafeId } from "../shared/validation";
import { success } from "../shared/response";

function parseDate(value: unknown): Timestamp {
  const date = new Date(value as string | number);
  if (!Number.isFinite(date.getTime())) throw new HttpsError("invalid-argument", "recordedAt is invalid.");
  return Timestamp.fromDate(date);
}

export const saveProgressEntry = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const input = request.data?.entry;
  if (!input || typeof input !== "object" || Array.isArray(input)) throw new HttpsError("invalid-argument", "entry is required.");
  const id = typeof input.id === "string" ? assertSafeId(input.id, "entry.id") : db.collection("_ids").doc().id;
  const data: Record<string, unknown> = {
    id,
    recordedAt: parseDate(input.recordedAt ?? Date.now()),
    updatedAt: FieldValue.serverTimestamp(),
  };
  for (const [field, min, max] of [
    ["weightKg", 1, 500],
    ["bodyFatPercentage", 0, 100],
    ["waistCircumferenceCm", 1, 300],
  ] as const) {
    if (input[field] !== undefined && input[field] !== null) data[field] = requireFiniteNumber(input[field], field, min, max);
  }
  if (input.notes !== undefined) {
    if (typeof input.notes !== "string" || input.notes.length > 1000) throw new HttpsError("invalid-argument", "notes is invalid.");
    data.notes = input.notes;
  }
  const ref = db.collection("users").doc(uid).collection("progress_entries").doc(id);
  const exists = await ref.get();
  if (!exists.exists) data.createdAt = FieldValue.serverTimestamp();
  await ref.set(data, { merge: true });
  return success({ entryId: id }, id);
});

export const deleteProgressEntry = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const id = assertSafeId(requireString(request.data?.entryId, "entryId", 128), "entryId");
  await db.collection("users").doc(uid).collection("progress_entries").doc(id).delete();
  return success({ deleted: true }, id);
});

export const getProgressHistory = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const pageSize = Math.min(Math.max(Number(request.data?.pageSize ?? 30), 1), 100);
  let query = db.collection("users").doc(uid).collection("progress_entries")
    .orderBy("recordedAt", "desc").limit(pageSize);
  if (request.data?.startDate) query = query.where("recordedAt", ">=", parseDate(request.data.startDate)) as typeof query;
  if (request.data?.endDate) query = query.where("recordedAt", "<=", parseDate(request.data.endDate)) as typeof query;
  const snapshot = await query.get();
  return success({
    entries: snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() })),
    hasMore: snapshot.size === pageSize,
  }, uid);
});