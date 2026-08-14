import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import {
  collection,
  doc,
  getDoc,
  getDocs,
  query,
  setDoc,
  updateDoc,
  where,
} from "firebase/firestore";
import { readFileSync } from "node:fs";
import { afterAll, beforeAll, describe, it } from "vitest";

let env: RulesTestEnvironment;

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: "demo-event-horizon",
    firestore: { rules: readFileSync("../firestore.rules", "utf8") },
  });
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, "bookings/bk1"), {
      userId: "alice",
      eventId: "pub1",
      status: "confirmed",
      totalAmount: 0,
    });
    await setDoc(doc(db, "events/pub1"), {
      title: "E",
      status: "published",
      organizerId: "org1",
    });
    await setDoc(doc(db, "events/pub1/buyers/alice"), { bookingCount: 2 });
  });
});

afterAll(async () => {
  await env.cleanup();
});

describe("bookings rules", () => {
  it("chủ đơn đọc được vé của mình", async () => {
    const alice = env.authenticatedContext("alice");
    await assertSucceeds(getDoc(doc(alice.firestore(), "bookings/bk1")));
  });

  it("người lạ KHÔNG đọc được vé người khác", async () => {
    const bob = env.authenticatedContext("bob");
    await assertFails(getDoc(doc(bob.firestore(), "bookings/bk1")));
  });

  it("query Vé của tôi (where userId == mình -> OK", async () => {
    const alice = env.authenticatedContext("alice");
    await assertSucceeds(
      getDocs(
        query(
          collection(alice.firestore(), "bookings"),
          where("userId", "==", "alice"),
        ),
      ),
    );
  });

  it("KẺ TẤN CÔNG: tự tạo booking (tự phát hành vé) -> bị chặn", async () => {
    const bob = env.authenticatedContext("bob");
    await assertFails(
      setDoc(doc(bob.firestore(), "bookings/fake1"), {
        userId: "bob",
        eventId: "pub1",
        status: "confirmed",
        totalAmount: 0,
      }),
    );
  });

  it("KẺ TẤN CÔNG: hồi sinh vé đã hủy (status -> confirmed) -> bị chặn", async () => {
    const alice = env.authenticatedContext("alice");
    await assertFails(
      updateDoc(doc(alice.firestore(), "bookings/bk1"), {
        status: "checkedIn",
      }),
    );
  });
});

describe("buyers rules", () => {
  it("đọc counter của CHÍNH MÌNH -> OK", async () => {
    const alice = env.authenticatedContext("alice");
    await assertSucceeds(
      getDoc(doc(alice.firestore(), "events/pub1/buyers/alice")),
    );
  });

  it("đọc counter người khác -> bị chặn", async () => {
    const bob = env.authenticatedContext("bob");
    await assertFails(getDoc(doc(bob.firestore(), "events/pub1/buyers/alice")));
  });

  it("KẺ TẤN CÔNG: tự reset bookingCount về 0 -> bị chặn", async () => {
    const alice = env.authenticatedContext("alice");
    await assertFails(
      updateDoc(doc(alice.firestore(), "events/pub1/buyers/alice"), {
        bookingCount: 0,
      }),
    );
  });
});
