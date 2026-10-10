import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { ref, remove, set } from "firebase/database";
import { readFileSync } from "node:fs";
import { afterAll, beforeAll, describe, it } from "vitest";

let env: RulesTestEnvironment;

function lock(uid: string, expiresInMs: number) {
  return {
    userId: uid,
    status: "selecting",
    expiresAt: Date.now() + expiresInMs,
  };
}

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: "demo-event-horizon",
    database: { rules: readFileSync("../database.rules.json", "utf-8") },
  });
});

afterAll(async () => {
  await env.cleanup();
});

describe("seatLocks rules", () => {
  it("khóa ghế trống cho chính mình -> OK", async () => {
    const alice = env.authenticatedContext("alice");
    await assertSucceeds(
      set(ref(alice.database(), "seatLocks/evt1/1-A1"), lock("alice", 60_000)),
    );
  });

  it("đè khóa CÒN HẠN của người khác -> bị chặn", async () => {
    const alice = env.authenticatedContext("alice");
    await set(
      ref(alice.database(), "seatLocks/evt1/1-A2"),
      lock("alice", 60_000),
    );
    const bob = env.authenticatedContext("bob");
    await assertFails(
      set(ref(bob.database(), "seatLocks/evt1/1-A2"), lock("bob", 60_000)),
    );
  });

  it("đè khóa HẾT HẠN của người khác -> OK", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      await set(ref(ctx.database(), "seatLocks/evt1/1-A3"), {
        userId: "alice",
        status: "selecting",
        expiresAt: Date.now() - 1000,
      });
    });
    const bob = env.authenticatedContext("bob");
    await assertSucceeds(
      set(ref(bob.database(), "seatLocks/evt1/1-A3"), lock("bob", 60_000)),
    );
  });

  it("khóa hộ NGƯỜI KHÁC (userId lạ) -> bị chặn", async () => {
    const alice = env.authenticatedContext("bob");
    await assertFails(
      set(ref(alice.database(), "seatLocks/evt1/1-A4"), lock("alice", 60_000)),
    );
  });

  it("KẺ ÔM GHẾ: expiresAt 1 tiếng -> bị chặn (trần 1 phút)", async () => {
    const alice = env.authenticatedContext("bob");
    await assertFails(
      set(ref(alice.database(), "seatLocks/evt1/1-A5"), lock("bob", 3_600_000)),
    );
  });

  it("client tự ghi status sold -> bị chặn", async () => {
    const alice = env.authenticatedContext("bob");
    await assertFails(
      set(ref(alice.database(), "seatLocks/evt1/1-A6"), {
        userId: "bob",
        status: "sold",
        expiresAt: Date.now() + 60_000,
      }),
    );
  });

  it("nhả khóa của CHÍNH MÌNH -> OK", async () => {
    const alice = env.authenticatedContext("alice");
    await set(
      ref(alice.database(), "seatLocks/evt1/1-A7"),
      lock("alice", 60_000),
    );
    await assertSucceeds(remove(ref(alice.database(), "seatLocks/evt1/1-A7")));
  });
});
