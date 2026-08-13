import { createHmac, timingSafeEqual } from "node:crypto";

export function buildQrData(
  bookingId: string,
  eventId: string,
  issuedAtMs: number,
): string {
  return `${bookingId}.${eventId}.${issuedAtMs}`;
}

export function signQr(qrData: string, secret: string): string {
  return createHmac("sha256", secret).update(qrData).digest("hex");
}

export function verifyQr(
  qrData: string,
  signature: string,
  secret: string,
): boolean {
  const expected = Buffer.from(signQr(qrData, secret), "hex");
  const actual = Buffer.from(signature, "hex");
  return expected.length === actual.length && timingSafeEqual(expected, actual);
}
