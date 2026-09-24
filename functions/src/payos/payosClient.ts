import { PayOS } from "@payos/node";

let cached: PayOS | null = null;

export function getPayOS(
  clientId: string,
  apiKey: string,
  checksumKey: string,
): PayOS {
  cached ??= new PayOS({
    clientId: clientId,
    apiKey,
    checksumKey,
  });
  return cached;
}
