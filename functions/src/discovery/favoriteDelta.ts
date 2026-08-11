export function favoriteDelta(before: boolean, after: boolean): number {
  if (!before && after) return 1;
  if (before && !after) return -1;
  return 0;
}
