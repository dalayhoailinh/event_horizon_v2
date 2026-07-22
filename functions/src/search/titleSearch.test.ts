import { describe, it, expect } from "vitest";
import { normalizeText, buildTitleSearch } from "./titleSearch";

const fixtures: Array<[string, string]> = [
  ["Dêm Nhạc Trịnh", "dem nhac trinh"],
  ["LỄ HỘI  Ánh Sáng", "le hoi anh sang"],
  ["Workshop UI/UX", "workshop ui/ux"],
];

describe("normalizeText", () => {
  it.each(fixtures)("chuẩn hóa '%s'", (raw, expcted) => {
    expect(normalizeText(raw)).toBe(expcted);
  });
});

describe("buildTitleSearch", () => {
  it("sinh mọi prefix của từng từ, không dấu", () => {
    const arr = buildTitleSearch("Đêm nhạc");
    expect(arr).toContain("d");
    expect(arr).toContain("dem");
    expect(arr).toContain("nhac");
    expect(arr).not.toContain("đêm");
  });

  it("từ lặp không sinh phần tử trùng", () => {
    const arr = buildTitleSearch("na na");
    expect(new Set(arr).size).toBe(arr.length);
  });
});
