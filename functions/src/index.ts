import { setGlobalOptions } from "firebase-functions/v2";
import { onCall } from "firebase-functions/v2/https";

setGlobalOptions({ region: "asia-southeast1", maxInstances: 2 });

export const ping = onCall(() => {
  return { message: "pong", serverTime: new Date().toISOString() };
});
