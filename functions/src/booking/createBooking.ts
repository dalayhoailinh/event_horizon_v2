import { defineSecret } from "firebase-functions/params";
import { createBookingSchema } from "./types";
import {
  DocumentSnapshot,
  FieldValue,
  getFirestore,
  Timestamp,
} from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/https";
import { EventState, planBooking, TicketTypeState } from "./planBooking";
import { buildQrData, signQr } from "./qr";

const qrSecret = defineSecret("QR_SECRET");

export const createBooking = onCall(
  { secrets: [qrSecret] },
  async (request) => {
    // Identity
    const auth = request.auth;
    if (!auth) {
      throw new HttpsError("unauthenticated", "Bạn cần đăng nhập để đặt vé.");
    }
    if (auth.token.email_verified !== true) {
      throw new HttpsError(
        "failed-precondition",
        "Bạn cần xác thực email để đặt vé.",
        { code: "email-not-verified" },
      );
    }

    // Input
    const parsed = createBookingSchema.safeParse(request.data);
    if (!parsed.success) {
      throw new HttpsError("invalid-argument", "Dữ liệu đầu vào không hợp lệ.");
    }
    const input = parsed.data;

    const db = getFirestore();
    const uid = auth.uid;

    const bookingId = `${uid}_${input.bookingIntentId}`;
    const bookingRef = db.doc(`bookings/${bookingId}`);
    const eventRef = db.doc(`events/${input.eventId}`);
    const buyerRef = eventRef.collection("buyers").doc(uid);

    return await db.runTransaction(async (tx) => {
      // Read
      const existing = await tx.get(bookingRef);
      if (existing.exists) {
        return { bookingId, duplicate: true };
      }
      const eventSnap = await tx.get(eventRef);
      const buyerSnap = await tx.get(buyerRef);
      const ttSnapById = new Map<string, DocumentSnapshot>();
      for (const item of input.items) {
        const ref = eventRef.collection("ticketTypes").doc(item.ticketTypeId);
        ttSnapById.set(item.ticketTypeId, await tx.get(ref));
      }

      const eventData = eventSnap.data();
      const event: EventState | null = eventData
        ? {
            status: eventData.status as string,
            startAtMs: (eventData.startAt as Timestamp).toMillis(),
            maxBookingsPerUser:
              (eventData.maxBookingsPerUser as number | undefined) ?? 0,
          }
        : null;
      const ticketTypes = new Map<string, TicketTypeState | null>();
      for (const [id, snap] of ttSnapById) {
        const d = snap.data();
        ticketTypes.set(
          id,
          d
            ? {
                id,
                name: d.name as string,
                price: d.price as number,
                quantity: d.quantity as number,
                sold: d.sold as number,
                isActive: d.isActive as boolean,
              }
            : null,
        );
      }

      const result = planBooking({
        input,
        event,
        ticketTypes,
        buyerBookingCount:
          (buyerSnap.data()?.bookingCount as number | undefined) ?? 0,
        nowMs: Date.now(),
      });
      if (!result.ok) {
        throw new HttpsError("failed-precondition", result.message, {
          code: result.code,
        });
      }

      // Write
      const now = Timestamp.now();
      const qrData = buildQrData(bookingId, input.eventId, now.toMillis());
      const venue = (eventData?.venue ?? {}) as {
        name?: string;
        address?: string;
      };
      tx.set(bookingRef, {
        userId: uid,
        customerName: (auth.token.name as string | undefined) ?? "",
        customerEmail: auth.token.email ?? "",
        organizerId: (eventData?.organizerId as string | undefined) ?? "",
        eventId: input.eventId,
        eventSnapshot: {
          title: (eventData?.title as string | undefined) ?? "",
          coverImageUrl: (eventData?.coverImageUrl as string | undefined) ?? "",
          startAt: eventData?.startAt ?? now,
          endAt: eventData?.endAt ?? now,
          venueName: venue.name ?? "",
          venueAddress: venue.address ?? "",
        },
        lineItems: result.plan.lineItems,
        totalAmount: result.plan.totalAmount,
        status: "confirmed",
        payment: {
          method: "free",
          status: "paid",
          paidAt: now,
        },
        ticket: {
          qrData,
          qrSignature: signQr(qrData, qrSecret.value()),
          issuedAt: now,
        },
        createdAt: now,
        confirmedAt: now,
      });
      for (const li of result.plan.lineItems) {
        tx.update(eventRef.collection("ticketTypes").doc(li.ticketTypeId), {
          sold: FieldValue.increment(li.quantity),
        });
      }
      tx.update(eventRef, {
        ticketsSold: FieldValue.increment(result.plan.ticketCount),
      });
      tx.set(
        buyerRef,
        {
          bookingCount: FieldValue.increment(1),
          updatedAt: now,
        },
        { merge: true },
      );

      return { bookingId, duplicate: false };
    });
  },
);
