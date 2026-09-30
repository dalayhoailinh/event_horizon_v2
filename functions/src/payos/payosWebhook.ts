import { onRequest } from "firebase-functions/https";
import { defineSecret } from "firebase-functions/params";
import { getPayOS } from "./payosClient";
import { logger } from "firebase-functions";
import { confirmPaidBooking } from "./confirmPaidBooking";
import { getFirestore } from "firebase-admin/firestore";

const clientId = defineSecret("PAYOS_CLIENT_ID");
const apiKey = defineSecret("PAYOS_API_KEY");
const checksumKey = defineSecret("PAYOS_CHECKSUM_KEY");
const qrSecret = defineSecret("QR_SECRET");

export const payosWebhook = onRequest(
  {
    secrets: [clientId, apiKey, checksumKey, qrSecret],
  },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method not allowed" });
      return;
    }

    const payos = getPayOS(
      clientId.value(),
      apiKey.value(),
      checksumKey.value(),
    );
    let data;
    try {
      data = await payos.webhooks.verify(req.body);
    } catch (e) {
      logger.warn("Webhook signature invalid", { error: String(e) });
      res.status(400).json({ error: "Invalid signature" });
      return;
    }

    if (data.code !== "00") {
      res.status(200).json({ success: true });
      return;
    }

    const outcome = await confirmPaidBooking({
      db: getFirestore(),
      orderCode: String(data.orderCode),
      paidAmount: data.amount,
      qrSecretValue: qrSecret.value(),
    });
    logger.info("Webhook processed", { orderCode: data.orderCode, outcome });
    res.status(200).json({ success: true });
  },
);
