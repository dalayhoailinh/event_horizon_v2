import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { readFileSync } from "node:fs";
import { confirmPaidBooking } from "../payos/confirmPaidBooking";

process.env.FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080";
process.env.GCLOUD_PROJECT = "event-horizon-v2";

initializeApp();
const db = getFirestore();

function localSecret(name: string): string {
  const line = readFileSync(".secret.local", "utf8")
    .split(/\r?\n/)
    .find((l) => l.startsWith(name + "="));
  if (!line) {
    throw new Error(`Missing secret ${name} in secrets.local`);
  }
  return line.slice(name.length + 1).trim();
}

async function main(): Promise<void> {
  const bookingId = process.argv[2];
  if (!bookingId) {
    throw new Error("Usage: npm run dev:pay -- <bookingId>");
  }
  const data = (await db.collection("bookings").doc(bookingId).get()).data();
  const orderCode = data?.payment?.payosOrderCode as string | undefined;
  if (!data || !orderCode) {
    throw new Error("No PayOS order yet - open the payment page first.");
  }
  const outcome = await confirmPaidBooking({
    db,
    orderCode,
    paidAmount: data.totalAmount as number,
    qrSecretValue: localSecret("QR_SECRET"),
  });
  console.log(`dev:pay ${bookingId} -> ${outcome}`);
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
