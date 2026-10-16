import { HttpsError } from "firebase-functions/v2/https";
import { db, FieldValue, Timestamp } from "./admin";

export async function enforceRateLimit(
  uid: string,
  operation: string,
  limit = 12,
  windowSeconds = 3600,
): Promise<void> {
  const now = Date.now();
  const ref = db.collection("ai_usage").doc(uid)
    .collection("operations").doc(operation);
  await db.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(ref);
    const data = snapshot.data();
    const windowStart = data?.windowStart instanceof Timestamp
      ? data.windowStart.toMillis()
      : 0;
    const count = windowStart > now - windowSeconds * 1000
      ? Number(data?.count ?? 0)
      : 0;
    if (count >= limit) {
      throw new HttpsError("resource-exhausted", "Usage limit reached. Try again later.");
    }
    transaction.set(ref, {
      count: count + 1,
      windowStart: windowStart > now - windowSeconds * 1000
        ? data?.windowStart
        : Timestamp.fromMillis(now),
      updatedAt: FieldValue.serverTimestamp(),
    }, { merge: true });
  });
}