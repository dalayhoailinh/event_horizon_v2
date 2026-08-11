import { describe, expect, it } from "vitest";
import { favoriteDelta } from "./favoriteDelta";

describe("favoriteDelta", () => {
  it("tạo mới -> +1", () => expect(favoriteDelta(false, true)).toBe(1));
  it("xóa -> -1", () => expect(favoriteDelta(true, false)).toBe(-1));
  it("update, vẫn tồn tại -> 0", () =>
    expect(favoriteDelta(true, true)).toBe(0));
  it("không tồn tại cả trước lẫn sau -> 0", () =>
    expect(favoriteDelta(false, false)).toBe(0));
});
