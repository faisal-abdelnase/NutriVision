import { onCall, HttpsError } from "firebase-functions/v2/https";
import { adminAuth, bucket, db, FieldValue } from "../shared/admin";
import { requireUid } from "../shared/validation";
import { success } from "../shared/response";

export const deleteUserAccount = onCall({ timeoutSeconds: 540, memory: "512MiB" }, async (request) => {
  const uid = requireUid(request.auth?.uid);
  const authTime = Number(request.auth?.token.auth_time ?? 0);
  if (!authTime || Date.now() / 1000 - authTime > 5 * 60) {
    throw new HttpsError("failed-precondition", "Please sign in again before deleting your account.");
  }
  const userRef = db.collection("users").doc(uid);
  await userRef.set({
    accountDeletionRequestedAt: FieldValue.serverTimestamp(),
    accountDeletionInProgress: true,
  }, { merge: true });

  // recursiveDelete removes the user document and every nested subcollection.
  await db.recursiveDelete(userRef);

  await db.recursiveDelete(db.collection("recipes").where("createdBy", "==", uid));
  await db.recursiveDelete(db.collection("ai_usage").doc(uid));

  // Remove user-owned files. If cleanup fails, the function errors so it can be retried.
  await bucket.deleteFiles({ prefix: "users/" + uid + "/" });

  // Finally delete the Firebase Authentication account.
  await adminAuth.deleteUser(uid);
  return success({ deleted: true }, uid);
});