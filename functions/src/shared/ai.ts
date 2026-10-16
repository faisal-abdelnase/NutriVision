import { defineSecret } from "firebase-functions/params";
import { HttpsError } from "firebase-functions/v2/https";

export const AI_API_KEY = defineSecret("AI_API_KEY");
const DEFAULT_MODEL = "gpt-4o-mini";

type ChatMessage = { role: "system" | "user" | "assistant"; content: string };

export async function askAI(
  messages: ChatMessage[],
  options: { json?: boolean; maxTokens?: number } = {},
): Promise<string> {
  const apiKey = AI_API_KEY.value();
  if (!apiKey) {
    throw new HttpsError("failed-precondition", "AI provider is not configured.");
  }

  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      "Authorization": "Bearer " + apiKey,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: DEFAULT_MODEL,
      messages,
      max_tokens: options.maxTokens ?? 900,
      ...(options.json ? { response_format: { type: "json_object" } } : {}),
    }),
    signal: AbortSignal.timeout(45000),
  });

  if (!response.ok) {
    // Never log or return provider response bodies; they may contain sensitive details.
    if (response.status === 429) {
      throw new HttpsError("resource-exhausted", "AI provider rate limit reached.");
    }
    if (response.status >= 500) {
      throw new HttpsError("unavailable", "AI provider is temporarily unavailable.");
    }
    throw new HttpsError("internal", "AI request failed.");
  }

  const payload = await response.json() as {
    choices?: Array<{ message?: { content?: string | null } }>;
  };
  const content = payload.choices?.[0]?.message?.content;
  if (typeof content !== "string" || !content.trim()) {
    throw new HttpsError("data-loss", "AI provider returned an empty response.");
  }
  return content;
}

export function parseJsonObject(text: string): Record<string, unknown> {
  try {
    const parsed: unknown = JSON.parse(text);
    if (parsed === null || Array.isArray(parsed) || typeof parsed !== "object") {
      throw new Error("Expected object");
    }
    return parsed as Record<string, unknown>;
  } catch {
    throw new HttpsError("data-loss", "AI provider returned invalid structured data.");
  }
}