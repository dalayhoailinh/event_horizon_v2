import { describe, expect, it } from "vitest";
import { buildQrData, signQr, verifyQr } from "./qr";

const SECRET = "test-secret";

describe("QR sign/verify", () => {
  const data = buildQrData("bk1", "evt007", 1800000000000);
  const sig = signQr(data, SECRET);

  it("ký rồi verify -> true", () => {
    expect(verifyQr(data, sig, SECRET)).toBe(true);
  });

  it("sửa 1 ký tự payload -> false (vé tự chế bị tắt", () => {
    expect(verifyQr(data.replace("bk1", "bk2"), sig, SECRET)).toBe(false);
  });

  it("secret khác -> false", () => {
    expect(verifyQr(data, sig, "other-secret")).toBe(false);
  });

  it("chữ ký rác không phải hex -> false, không crash", () => {
    expect(verifyQr(data, "zzzz", SECRET)).toBe(false);
  });

  it("chữ ký rỗng -> false, không crash", () => {
    expect(verifyQr(data, "", SECRET)).toBe(false);
  });

  it("đúng độ dài nhưng sai 1 ký tự -> false", () => {
    const tampered = sig.slice(0, -1) + (sig.endsWith("0") ? "1" : "0");
    expect(verifyQr(data, tampered, SECRET)).toBe(false);
  });
});
