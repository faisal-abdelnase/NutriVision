export type ApiResponse<T> = {
  ok: true;
  data: T;
  requestId: string;
};

export function success<T>(data: T, requestId: string): ApiResponse<T> {
  return { ok: true, data, requestId };
}