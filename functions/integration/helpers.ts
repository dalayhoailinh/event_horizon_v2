import { randomUUID } from "node:crypto";
import { initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore, Timestamp } from "firebase-admin/firestore";

process.env.FIRESTORE_EMULATOR_HOST ??= "127.0.0.1:8080";
process.env.FIREBASE_AUTH_EMULATOR_HOST ??= "127.0.0.1:9099";

const PROJECT = process.env.GCLOUD_PROJECT ?? "event-horizon-v2";
const FN_BASE = `http://127.0.0.1:5001/${PROJECT}/asia-southeast1`;
const AUTH_BASE = "http://127.0.0.1:9099/identitytoolkit.googleapis.com/v1";

initializeApp({ projectId: PROJECT });
export const db = getFirestore();

export type CallResult = {
  result?: { bookingId?: string; duplicate?: boolean; ok?: boolean };
  error?: { message: string; status: string; details?: { code?: string } };
};

let userSeq = 0;

export async function verifiedUser(): Promise<{
  uid: string;
  idToken: string;
}> {
  userSeq++;
  const email = `it-user-${userSeq}-${randomUUID()}@test.com`;
  const password = "secret123";
  const signUpRes = await fetch(`${AUTH_BASE}/accounts:signUp?key=fake`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password, returnSecureToken: true }),
  });
  const signUp = (await signUpRes.json()) as { localId: string };
  if (!signUp.localId) {
    throw new Error(`Failed to sign up user: ${JSON.stringify(signUp)}`);
  }
  await getAuth().updateUser(signUp.localId, { emailVerified: true });
  const signInRes = await fetch(
    `${AUTH_BASE}/accounts:signInWithPassword?key=fake`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password, returnSecureToken: true }),
    },
  );
  const signIn = (await signInRes.json()) as { idToken: string };
  return { uid: signUp.localId, idToken: signIn.idToken };
}

export async function call(
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

export async function seedEvent(
  options: {
    remaining?: number;
    maxBookings?: number;
    price?: number;
  } = {},
): Promise<string> {
  eventSeq++;
  const id = `it-evt-${Date.now()}-${eventSeq}`;
  const { remaining = 10, maxBookings = 10, price = 0 } = options;
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

export function intent(): string {
  return `it${Date.now()}-${Math.random().toString(36).substring(2, 16)}`;
}

export async function soldOf(eventId: string): Promise<number> {
  const snap = await db.doc(`events/${eventId}/ticketTypes/t1`).get();
  return (snap.data()?.sold as number) ?? 0;
}
