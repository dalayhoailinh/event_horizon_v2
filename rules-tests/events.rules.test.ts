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
  serverTimestamp,
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
    await setDoc(doc(db, "events/pub1"), {
      title: "Đêm nhạc",
      status: "published",
      organizerId: "org1",
      ticketsSold: 10,
    });
    await setDoc(doc(db, "events/draft1"), {
      title: "Nháp",
      status: "draft",
      organizerId: "org1",
    });
    await setDoc(doc(db, "events/pub1/ticketTypes/t1"), {
      name: "Thường",
      price: 2000,
      quantity: 100,
      sold: 10,
    });
    await setDoc(doc(db, "events/draft1/ticketTypes/t1"), {
      name: "Thường",
      price: 1,
      quantity: 1,
      sold: 0,
    });
    await setDoc(doc(db, "events/pub1/search/main"), { embedding: [1, 2] });
    await setDoc(doc(db, "categories/music"), {
      name: "Âm nhạc",
      status: "approved",
    });
    await setDoc(doc(db, "categories/waiting"), {
      name: "Chờ duyệt",
      status: "pending",
    });
  });
});

afterAll(async () => {
  await env.cleanup();
});

describe("events rules", () => {
  it("khách CHƯA đăng nhập vẫn đọc được event published", async () => {
    const guest = env.unauthenticatedContext();
    await assertSucceeds(getDoc(doc(guest.firestore(), "events/pub1")));
  });

  it("người lạ KHÔNG đọc được event draft", async () => {
    const bob = env.authenticatedContext("bob");
    await assertFails(getDoc(doc(bob.firestore(), "events/draft1")));
  });

  it("organizer đọc được draft của CHÍNH MÌNH", async () => {
    const org = env.authenticatedContext("org1");
    await assertSucceeds(getDoc(doc(org.firestore(), "events/draft1")));
  });

  it("query KHÔNG lọc status -> bị chặn (rules không phải filter)", async () => {
    const bob = env.authenticatedContext("bob");
    await assertFails(getDocs(collection(bob.firestore(), "events")));
  });

  it("query có where status == 'published' -> OK", async () => {
    const bob = env.authenticatedContext("bob");
    await assertSucceeds(
      getDocs(
        query(
          collection(bob.firestore(), "events"),
          where("status", "==", "published"),
        ),
      ),
    );
  });

  it("ticketTypes: đọc của của published, KHÔNG của draft", async () => {
    const bob = env.authenticatedContext("bob");
    await assertSucceeds(
      getDoc(doc(bob.firestore(), "events/pub1/ticketTypes/t1")),
    );
    await assertFails(
      getDoc(doc(bob.firestore(), "events/draft1/ticketTypes/t1")),
    );
  });

  it("search/main (embedding): cấm đọc kể cả khi event published", async () => {
    const bob = env.authenticatedContext("bob");
    await assertFails(getDoc(doc(bob.firestore(), "events/pub1/search/main")));
  });

  it("KẺ TẤN CÔNG: client sửa ticketsSold -> bị chặn", async () => {
    const bob = env.authenticatedContext("bob");
    await assertFails(
      updateDoc(doc(bob.firestore(), "events/pub1"), {
        ticketsSold: 1000,
      }),
    );
  });
});

describe("categories & favorites rules", () => {
  it("category approved đọc được, pending thì không", async () => {
    const bob = env.authenticatedContext("bob");
    await assertSucceeds(getDoc(doc(bob.firestore(), "categories/music")));
    await assertFails(getDoc(doc(bob.firestore(), "categories/waiting")));
  });

  it("favorite: tạo cho CHÍNH MÌNH với serverTimestamp -> OK", async () => {
    const alice = env.authenticatedContext("alice");
    await assertSucceeds(
      setDoc(doc(alice.firestore(), "users/alice/favorites/pub1"), {
        createdAt: serverTimestamp(),
      }),
    );
  });

  it("favorite: nhét field lạ ngoài createdAt -> bị chặn", async () => {
    const alice = env.authenticatedContext("alice");
    await assertFails(
      setDoc(doc(alice.firestore(), "users/alice/favorites/pub2"), {
        createdAt: serverTimestamp(),
        note: "hack",
      }),
    );
  });
});
