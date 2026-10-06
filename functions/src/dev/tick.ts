import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { expireDueBookings } from "../booking/expireBookings";

process.env.FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080";
process.env.GCLOUD_PROJECT = "event-horizon-v2";

initializeApp();

async function main(): Promise<void> {
  const db = getFirestore();
  const expired = await expireDueBookings(db);
  console.log(`dev:tick -> expired ${expired} booking(s)`);
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
