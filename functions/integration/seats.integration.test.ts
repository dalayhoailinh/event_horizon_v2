import { Timestamp } from "firebase-admin/firestore";
import { call, db, intent, verifiedUser } from "./helpers";
import { describe, expect, it } from "vitest";

let seq = 0;

async function seedSeatEvent(): Promise<string> {
  seq += 1;
  const id = `it-seat-${Date.now()}-${seq}`;
  await db.doc(`events/${id}`).set({
    title: "Seat test",
    coverImageUrl: "",
    status: "published",
    organizerId: "org-it",
    startAt: Timestamp.fromMillis(Date.now() + 86_400_000),
    endAt: Timestamp.fromMillis(Date.now() + 90_000_000),
    venue: { name: "V", address: "A", provinceCode: "SG" },
    maxBookingsPerUser: 4,
    ticketsSold: 0,
    minPrice: 200_000,
    maxPrice: 200_000,
    favoriteCount: 0,
    hasSeatMap: true,
  });
  await db.doc(`events/${id}/ticketTypes/t1`).set({
    name: "Ngồi",
    description: "",
    price: 200_000,
    currency: "VND",
    quantity: 3,
    sold: 0,
    seatCodes: ["1-A1", "1-A2", "1-A3"],
    sortOrder: 0,
    isActive: true,
  });
  await db.doc(`events/${id}/seatmap/sold`).set({ codes: {} });
  return id;
}

async function soldCodes(eventId: string): Promise<string[]> {
  const snap = await db.doc(`events/${eventId}/seatmap/sold`).get();
  return Object.keys(snap.data()?.codes ?? {});
}

describe("createBooking với ghế (emulator)", () => {
  it("đặt ghế -> đơn giữ ghế trong sold-map", async () => {
    const eventId = await seedSeatEvent();
    const user = await verifiedUser();
    const res = await call("createBooking", user.idToken, {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 2, seatCodes: ["1-A1", "1-A2"] }],
    });
    expect(res.error).toBeUndefined();
    expect(await soldCodes(eventId)).toEqual(
      expect.arrayContaining(["1-A1", "1-A2"]),
    );
  }, 30_000);

  it("2 người tranh 1 GHẾ song song -> đúng 1 thắng", async () => {
    const eventId = await seedSeatEvent();
    const [alice, bob] = await Promise.all([verifiedUser(), verifiedUser()]);
    const dataFor = () => ({
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 1, seatCodes: ["1-A1"] }],
    });

    const [r1, r2] = await Promise.all([
      call("createBooking", alice.idToken, dataFor()),
      call("createBooking", bob.idToken, dataFor()),
    ]);
    const wins = [r1, r2].filter((r) => r.result?.bookingId).length;
    const losses = [r1, r2].filter(
      (r) => r.error?.details?.code === "seat-taken",
    ).length;
    expect(wins).toBe(1);
    expect(losses).toBe(1);
  }, 30_000);
});
