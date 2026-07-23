int responsiveColumns({
  required double availableWidth,
  double targetTileWidth = 340,
  int min = 1,
  int max = 4,
}) {
  final count = (availableWidth / targetTileWidth).floor();
  return count.clamp(min, max);
}
