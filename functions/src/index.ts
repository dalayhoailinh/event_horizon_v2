import "./init";

import { onCall } from "firebase-functions/v2/https";

export { onUserCreated } from "./auth/onUserCreated";

export { setUserRole } from "./auth/setUserRole";

export const ping = onCall(() => {
  return { message: "pong", serverTime: new Date().toISOString() };
});
