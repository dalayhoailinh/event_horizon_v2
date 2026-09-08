import "./init";

import { onCall } from "firebase-functions/v2/https";

export { onUserCreated } from "./auth/onUserCreated";

export { setUserRole } from "./auth/setUserRole";

export { onFavoriteWritten } from "./discovery/onFavoriteWritten";

export { createBooking } from "./booking/createBooking";

export const ping = onCall(() => {
  return { message: "pong", serverTime: new Date().toISOString() };
});
