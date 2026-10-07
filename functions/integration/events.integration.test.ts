import { Timestamp } from "firebase-admin/firestore";
import { describe, expect, it } from "vitest";
import { db } from "./helpers";
import { endDueEvents } from "../src/events/endEvents";

describe("endDueEvents (emulator)", () => {
  it("published đã qua endAt -> ended; chưa qua thì giữ nguyên", async () => {
    const stamp = Date.now();
    const pastId = `it-end-past-${stamp}`;
    const futureId = `it-end-future-${stamp}`;
    await db
      .collection("events")
      .doc(pastId)
      .set({
        status: "published",
        endAt: Timestamp.fromMillis(stamp - 1000),
      });
    await db
      .collection("events")
      .doc(futureId)
      .set({
        status: "published",
        endAt: Timestamp.fromMillis(stamp + 86_400_000),
      });

    await endDueEvents(db);

    const past = await db.collection("events").doc(pastId).get();
    const future = await db.collection("events").doc(futureId).get();
    expect(past.data()?.status).toBe("ended");
    expect(future.data()?.status).toBe("published");
  }, 30_000);
});
