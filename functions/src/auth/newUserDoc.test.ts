import { describe, expect, it } from "vitest";

import { buildNewUserDoc } from "./newUserDoc";

describe("buildNewUserDoc", () => {
  it("mặc định role user + isActive true", () => {
    const doc = buildNewUserDoc({
      uid: "u1",
      email: "a@b.c",
      displayName: "An",
    });
    expect(doc.role).toBe("user");
    expect(doc.isActive).toBe(true);
    expect(doc.id).toBe("u1");
  });

  it("email/displayName rỗng vẫn hợp lệ (tài khoản Google có thể thiếu tên)", () => {
    const doc = buildNewUserDoc({ uid: "u2", email: "", displayName: "" });
    expect(doc.displayName).toBe("");
  });
});
