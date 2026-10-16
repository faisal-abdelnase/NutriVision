import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { getMessaging } from "firebase-admin/messaging";
import { db, FieldValue, Timestamp } from "../shared/admin";
import { requireUid, requireString, assertSafeId } from "../shared/validation";
import { success } from "../shared/response";

export const registerDeviceToken = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const token = requireString(request.data?.token, "token", 4096);
  const deviceId = assertSafeId(requireString(request.data?.deviceId, "deviceId", 128), "deviceId");
  const platform = request.data?.platform;
  if (!["android", "ios", "web"].includes(platform)) throw new HttpsError("invalid-argument", "Unsupported platform.");
  await db.collection("users").doc(uid).collection("devices").doc(deviceId).set({
    token, platform, updatedAt: FieldValue.serverTimestamp(),
  }, { merge: true });
  return success({ registered: true }, deviceId);
});

export const scheduleMealReminder = onCall(async (request) => {
  const uid = requireUid(request.auth?.uid, request.data?.uid);
  const hour = Number(request.data?.hour);
  const minute = Number(request.data?.minute);
  const timezone = requireString(request.data?.timezone, "timezone", 80);
  if (!Number.isInteger(hour) || hour < 0 || hour > 23 ||
      !Number.isInteger(minute) || minute < 0 || minute > 59) {
    throw new HttpsError("invalid-argument", "Reminder time is invalid.");
  }
  const ref = db.collection("users").doc(uid).collection("reminders").doc("meal");
  await ref.set({
    enabled: request.data?.enabled !== false,
    hour, minute, timezone,
    updatedAt: FieldValue.serverTimestamp(),
  }, { merge: true });
  return success({ saved: true }, uid);
});

export const sendScheduledReminders = onSchedule("every 5 minutes", async () => {
  const now = new Date();
  const reminders = await db.collectionGroup("reminders").where("enabled", "==", true).limit(500).get();
  for (const reminder of reminders.docs) {
    const uid = reminder.ref.path.split("/")[1];
    const data = reminder.data();
    let local: string;
    try {
      local = new Intl.DateTimeFormat("en-GB", {
        timeZone: String(data.timezone),
        hour: "2-digit", minute: "2-digit", hourCycle: "h23",
      }).format(now);
    } catch {
      continue;
    }
    const [hour, minute] = local.split(":").map(Number);
    if (hour !== Number(data.hour) || minute < Number(data.minute) || minute >= Number(data.minute) + 5) continue;
    const dateKey = new Intl.DateTimeFormat("en-CA", { timeZone: String(data.timezone), year: "numeric", month: "2-digit", day: "2-digit" }).format(now);
    const sendRef = db.collection("users").doc(uid).collection("reminder_sends").doc("meal_" + dateKey + "_" + data.hour + "_" + data.minute);
    const alreadySent = await sendRef.get();
    if (alreadySent.exists) continue;
    const devices = await db.collection("users").doc(uid).collection("devices").get();
    const tokens = devices.docs.map((doc) => doc.data().token).filter((token): token is string => typeof token === "string" && token.length > 0);
    if (tokens.length === 0) continue;
    const response = await getMessaging().sendEachForMulticast({
      tokens,
      notification: { title: "NutriVision", body: "It's time to log your meal." },
      data: { type: "meal_reminder", route: "/meal-tracking" },
    });
    await sendRef.set({
      sentAt: FieldValue.serverTimestamp(),
      successCount: response.successCount,
      failureCount: response.failureCount,
    });
    const invalidTokens: string[] = [];
    response.responses.forEach((result, index) => {
      if (!result.success && ["messaging/registration-token-not-registered", "messaging/invalid-registration-token"].includes(result.error?.code ?? "")) {
        invalidTokens.push(tokens[index]);
      }
    });
    if (invalidTokens.length) {
      const batch = db.batch();
      for (const doc of devices.docs) {
        if (invalidTokens.includes(String(doc.data().token))) batch.delete(doc.ref);
      }
      await batch.commit();
    }
  }
});