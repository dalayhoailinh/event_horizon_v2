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

// "Đêm nhạc" -> ["d", "de", "dem", "n", "nh", "nha", "nhac"]
export function buildTitleSearch(title: string): string[] {
  const prefixes = new Set<string>();
  for (const word of normalizeText(title).split(" ")) {
    for (let i = 1; i <= word.length; i++) {
      prefixes.add(word.slice(0, i));
    }
  }
  return [...prefixes];
}
