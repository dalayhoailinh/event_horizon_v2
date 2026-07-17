import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { doc, getDoc, setDoc, updateDoc } from "firebase/firestore";
import { readFileSync } from "node:fs";
import { afterAll, beforeAll, describe, it } from "vitest";

let env: RulesTestEnvironment;

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: "demo-event-horizon",
    firestore: { rules: readFileSync("../firestore.rules", "utf8") },
  });
  await env.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), "users/alice"), {
      id: "alice",
      role: "user",
      displayName: "Alice",
      isActive: true,
    });
  });
});

afterAll(async () => {
  await env.cleanup();
});

describe("users rules", () => {
  it("chỉ doc đọc được doc của mình", async () => {
    const alice = env.authenticatedContext("alice");
    await assertSucceeds(getDoc(doc(alice.firestore(), "users/alice")));
  });

  it("người khác KHÔNG đọc được", async () => {
    const bob = env.authenticatedContext("bob");
    await assertFails(getDoc(doc(bob.firestore(), "users/alice")));
  });

  it("admin (qua claims) đọc được mọi user", async () => {
    const admin = env.authenticatedContext("root", { role: "admin" });
    await assertSucceeds(getDoc(doc(admin.firestore(), "users/alice")));
  });

  it("sửa displayName của mình: OK", async () => {
    const alice = env.authenticatedContext("alice");
    await assertSucceeds(
      updateDoc(doc(alice.firestore(), "users/alice"), {
        displayName: "Alice Mới",
      }),
    );
  });

  it("KẺ TẤN CÔNG: tự nâng role -> bị chặn", async () => {
    const alice = env.authenticatedContext("alice");
    await assertFails(
      updateDoc(doc(alice.firestore(), "users/alice"), {
        role: "admin",
      }),
    );
  });

  it("admin CLIENT cũng không sửa role trực tiếp (phải qua setUserRole)", async () => {
    const admin = env.authenticatedContext("root", { role: "admin" });
    await assertFails(
      updateDoc(doc(admin.firestore(), "users/alice"), {
        role: "organizer",
      }),
    );
  });

  it("client KHÔNG tự tạo users doc (server-only)", async () => {
    const carol = env.authenticatedContext("carol");
    await assertFails(
      setDoc(doc(carol.firestore(), "users/carol"), {
        id: "carol",
        role: "user",
      }),
    );
  });
});
