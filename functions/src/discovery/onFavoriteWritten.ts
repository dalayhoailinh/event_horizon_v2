import { onDocumentWritten } from "firebase-functions/firestore";
import { favoriteDelta } from "./favoriteDelta";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions";

export const onFavoriteWritten = onDocumentWritten(
  "users/{uid}/favorites/{eventId}",
  async (event) => {
    const delta = favoriteDelta(
      event.data?.before.exists ?? false,
      event.data?.after.exists ?? false,
    );
    if (delta === 0) return;

    const { eventId } = event.params;
    try {
      await getFirestore()
        .doc(`events/${eventId}`)
        .update({
          favoriteCount: FieldValue.increment(delta),
        });
    } catch (error) {
      logger.warn("favoriteCount update failed", {
        eventId,
        delta,
        error: String(error),
      });
    }
  },
);
