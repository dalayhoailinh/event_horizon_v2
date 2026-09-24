const MAX_LENGTH = 25;
const FALLBACK = "Dat ve su kien";

// Sanitize PAYOS transfer content.
export function sanitizeDescription(raw: string): string {
  const noDiacritics = raw
    // Decompose the letters from the diacritics
    .normalize("NFD")
    // Remove the diacritical marks that have been separated.
    .replace(/[̀-ͯ]/g, "")
    // Replace Vietnamese-specific characters
    .replace(/đ/g, "d")
    // Replace Vietnamese-specific characters
    .replace(/Đ/g, "D");
  const asciiOnly = noDiacritics
    // Keep only letters, numbers, and spaces.
    .replace(/[^a-zA-Z0-9 ]/g, "")
    .trim();
  const collapsed = asciiOnly
    // Collapse multiple spaces into one.
    .replace(/\s+/g, " ");
  const truncated = collapsed.substring(0, MAX_LENGTH).trim();
  return truncated.length > 0 ? truncated : FALLBACK;
}
