import { describe, expect, it } from "vitest";
import { sanitizeDescription } from "./sanitizeDescription";

describe("sanitizeDescription", () => {
  it("bỏ dấu + cắt 25 ký tự", () => {
    const out = sanitizeDescription("Đêm nhạc Trịnh - đêm diễn đặc biệt");
    expect(out.length).toBeLessThanOrEqual(25);
    expect(out.startsWith("Dem nhac Trinh")).toBe(true);
  });

  it("toàn ký tự đặc biệt -> fallback", () => {
    expect(sanitizeDescription("!@#$%^&*()_+")).toBe("Dat ve su kien");
  });
});
