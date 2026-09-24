import { getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/https";
import { defineSecret, defineString } from "firebase-functions/params";
import { z } from "zod";
import { sanitizeDescription } from "./sanitizeDescription";
import { getPayOS } from "./payosClient";
import { logger } from "firebase-functions";

const appBaseUrl = defineString("APP_BASE_URL", {
  default: "http://localhost:5000",
});

const clientId = defineSecret("PAYOS_CLIENT_ID");
const apiKey = defineSecret("PAYOS_API_KEY");
const checksumKey = defineSecret("PAYOS_CHECKSUM_KEY");

const schema = z.object({ bookingId: z.string().min(1) });

export const createPayosOrder = onCall(
  { secrets: [clientId, apiKey, checksumKey] },
  async (request) => {
    const auth = request.auth;
    if (!auth) {
      throw new HttpsError("unauthenticated", "Bạn cần đăng nhập để đặt vé.");
    }
    const parsed = schema.safeParse(request.data);
    if (!parsed.success) {
      throw new HttpsError("invalid-argument", "Dữ liệu không hợp lệ.");
    }

    const bookingRef = getFirestore()
      .collection("bookings")
      .doc(parsed.data.bookingId);
    const snap = await bookingRef.get();
    const data = snap.data();
    if (!data || data.userId !== auth.uid) {
      throw new HttpsError("failed-precondition", "Không tìm thấy đơn.", {
        code: "booking-not-found",
      });
    }
    if (data.status !== "pendingPayment") {
      throw new HttpsError(
        "failed-precondition",
        "Đơn không ở trạng thái chờ thanh toán.",
        { code: "not-pending" },
      );
    }

    const payment = (data.payment ?? {}) as Record<string, unknown>;
    if (payment.payosOrderCode && payment.qr) {
      return { qrCode: payment.qr };
    }

    const amount = data.totalAmount as number;
    const orderCode = (Math.floor(Date.now() / 100) % 999_999_999) + 1;
    const description = sanitizeDescription(
      (data.eventSnapshot?.title as string | undefined) ?? "Dat ve",
    );

    const payos = getPayOS(
      clientId.value(),
      apiKey.value(),
      checksumKey.value(),
    );
    let link;
    try {
      link = await payos.paymentRequests.create({
        orderCode,
        amount,
        description,
        returnUrl: `${appBaseUrl.value()}/#/my-tickets`,
        cancelUrl: `${appBaseUrl.value()}/#/my-tickets`,
      });
    } catch (e) {
      logger.error("PayOS create payment link failed", {
        bookingId: bookingRef.id,
        error: String(e),
      });
      throw new HttpsError(
        "failed-precondition",
        "Cổng thanh toán đang lỗi. Vui lòng thử lại sau.",
        { code: "payment-gateway-error" },
      );
    }

    await bookingRef.update({
      "payment.payosOrderCode": String(orderCode),
      "payment.payosPaymentLinkId": link.paymentLinkId,
      "payment.qr": link.qrCode,
    });
    return { qrCode: link.qrCode };
  },
);
