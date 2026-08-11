// "Đêm nhạc" -> "dem nhac"
export function normalizeText(input: string): string {
  return input
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/đ/g, "d")
    .replace(/\s+/g, " ")
    .trim();
}

export const MAX_SEARCH_PREFIX = 30;

// "Đêm nhạc" -> ["d","de","dem","dem ","dem n",…,"dem nhac","n","nh","nha","nhac"]
export function buildTitleSearch(title: string): string[] {
  const normalized = normalizeText(title);
  if (normalized === "") return [];

  const words = normalized.split(" ");
  const prefixes = new Set<string>();
  for (let start = 0; start < words.length; start++) {
    const phrase = words.slice(start).join(" ");
    const limit = Math.min(phrase.length, MAX_SEARCH_PREFIX);
    for (let i = 1; i <= limit && prefixes.size < MAX_SEARCH_PREFIX; i++) {
      prefixes.add(phrase.slice(0, i));
    }
  }
  return [...prefixes];
}
