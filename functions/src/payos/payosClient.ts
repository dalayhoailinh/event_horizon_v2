import { PayOS } from "@payos/node";

let cached: PayOS | null = null;

export function getPayOS(
  cliendId: string,
  apiKey: string,
  checksumKey: string,
): PayOS {
  cached ??= new PayOS({
    clientId: cliendId,
    apiKey,
    checksumKey,
  });
  return cached;
}
