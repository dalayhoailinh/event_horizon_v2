process.env.FIRESTORE_EMULATOR_HOST ??= "127.0.0.1:8080";
process.env.FIREBASE_AUTH_EMULATOR_HOST ??= "127.0.0.1:9099";

import { initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { describe, expect, it } from "vitest";
import { type CreateBookingInput } from "../src/booking/types";

const PROJECT = process.env.GCLOUD_PROJECT ?? "event-horizon-v2";
const FN_BASE = `http://127.0.0.1:5001/${PROJECT}/asia-southeast1`;
const AUTH_BASE = "http://127.0.0.1:9099/identitytoolkit.googleapis.com/v1";

initializeApp({ projectId: PROJECT });
const db = getFirestore();

type CallResult = {
  result?: { bookingId?: string; duplicate?: boolean; ok?: boolean };
  error?: { message: string; status: string; details?: { code?: string } };
};

let userSeq = 0;

async function verifiedUser(): Promise<{ uid: string; idToken: string }> {
  userSeq++;
  const email = `it-user-${Date.now()}-${userSeq}@test.com`;
  const password = "secret123";
  const signUpRes = await fetch(`${AUTH_BASE}/accounts:signUp?key=fake`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password, returnSecureToken: true }),
  });
  const signUp = (await signUpRes.json()) as { localId: string };
  await getAuth().updateUser(signUp.localId, { emailVerified: true });
  const SignInRes = await fetch(
    `${AUTH_BASE}/accounts:signInWithPassword?key=fake`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password, returnSecureToken: true }),
    },
  );
  const signIn = (await SignInRes.json()) as { idToken: string };
  return { uid: signUp.localId, idToken: signIn.idToken };
}

async function call(
  name: string,
  idToken: string,
  data: unknown,
): Promise<CallResult> {
  const res = await fetch(`${FN_BASE}/${name}`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${idToken}`,
    },
    body: JSON.stringify({ data }),
  });
  return (await res.json()) as CallResult;
}

let eventSeq = 0;

async function seedEvent(
  options: {
    remaining?: number;
    maxBookings?: number;
    price?: number;
  } = {},
): Promise<string> {
  eventSeq++;
  const id = `it-evt-${Date.now()}-${eventSeq}`;
  const { remaining = 10, maxBookings = 4, price = 0 } = options;
  await db.doc(`events/${id}`).set({
    title: "Sự kiện integration test",
    coverImageUrl: "",
    status: "published",
    organizerId: "org-it",
    startAt: Timestamp.fromMillis(Date.now() + 86_400_000),
    endAt: Timestamp.fromMillis(Date.now() + 90_000_000),
    venue: { name: "Hội trường", address: "1 Đường A", provinceCode: "SG" },
    maxBookingsPerUser: maxBookings,
    ticketsSold: 0,
    minPrice: price,
    maxPrice: price,
    favoriteCount: 0,
    hasSeatMap: false,
  });
  await db.doc(`events/${id}/ticketTypes/t1`).set({
    name: "Vé mời",
    description: "",
    price,
    currency: "VND",
    quantity: remaining,
    sold: 0,
    seatCodes: null,
    sortOrder: 0,
    isActive: true,
  });
  return id;
}

function intent(): string {
  return `it${Date.now()}${Math.random().toString(36).substring(2, 12)}`;
}

async function soldOf(eventId: string): Promise<number> {
  const snap = await db.doc(`events/${eventId}/ticketTypes/t1`).get();
  return (snap.data()?.sold as number) ?? 0;
}

describe("createBooking (emulator)", () => {
  it("đặt thành công + retry cùng intent -> KHÔNG tạo đơn đôi", async () => {
    const eventId = await seedEvent();
    const user = await verifiedUser();
    const data: CreateBookingInput = {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 2 }],
    };

    const first = await call("createBooking", user.idToken, data);
    expect(first.error).toBeUndefined();
    const retry = await call("createBooking", user.idToken, data);
    expect(retry.result?.bookingId).toBe(first.result?.bookingId);
    expect(retry.result?.duplicate).toBe(true);

    expect(await soldOf(eventId)).toBe(2);
  }, 30_000);

  it("quá hạn mức đơn/người -> booking-limit", async () => {
    const eventId = await seedEvent({ maxBookings: 2 });
    const user = await verifiedUser();
    const book = () =>
      call("createBooking", user.idToken, {
        eventId,
        bookingIntentId: intent(),
        items: [{ ticketTypeId: "t1", quantity: 1 }],
      });

    expect((await book()).error).toBeUndefined();
    expect((await book()).error).toBeUndefined();
    const third = await book();
    expect(third.error?.details?.code).toBe("booking-limit");
  }, 30_000);

  it("vé trả phí -> paid-not-supported (cổng GĐ4)", async () => {
    const eventId = await seedEvent({ price: 200_000 });
    const user = await verifiedUser();
    const res = await call("createBooking", user.idToken, {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 1 }],
    });
    expect(res.error?.details?.code).toBe("paid-not-supported");
  }, 30_000);
});

describe("cancelBooking (emulator)", () => {
  it("hủy -> hoàn kho + hoàn counter -> đặt lại được", async () => {
    const eventId = await seedEvent({ maxBookings: 1 });
    const user = await verifiedUser();
    const first = await call("createBooking", user.idToken, {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 2 }],
    });
    expect(await soldOf(eventId)).toBe(2);

    const cancel = await call("cancelBooking", user.idToken, {
      bookingId: first.result?.bookingId,
    });
    expect(cancel.error).toBeUndefined();
    expect(await soldOf(eventId)).toBe(0);

    const again = await call("createBooking", user.idToken, {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 1 }],
    });
    expect(again.error).toBeUndefined();
  }, 30_000);

  it("hủy đơn của NGƯỜI KHÁC -> not-owner", async () => {
    const eventId = await seedEvent();
    const [alice, bob] = await Promise.all([verifiedUser(), verifiedUser()]);
    const created = await call("createBooking", alice.idToken, {
      eventId,
      bookingIntentId: intent(),
      items: [{ ticketTypeId: "t1", quantity: 1 }],
    });
    const res = await call("cancelBooking", bob.idToken, {
      bookingId: created.result?.bookingId,
    });
    expect(res.error?.details?.code).toBe("not-owner");
  }, 30_000);
});
