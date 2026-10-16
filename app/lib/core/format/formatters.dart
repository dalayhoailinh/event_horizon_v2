String formatVnd(int amount) {
  if (amount == 0) return 'Miễn phí';
  final grouped = amount.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return '$groupedđ';
}

String formatPriceRange(int minPrice, int maxPrice) {
  if (maxPrice == 0) return 'Miễn phí';
  if (minPrice == maxPrice) return formatVnd(minPrice);
  return 'Từ ${formatVnd(minPrice)}';
}

const _weekdayShort = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

String _two(int n) => n.toString().padLeft(2, '0');

String formatEventTime(DateTime dt) {
  final wd = _weekdayShort[dt.weekday % 7];
  return '$wd · ${_two(dt.day)}/${_two(dt.month)}/${dt.year}'
      ' · ${_two(dt.hour)}:${_two(dt.minute)}';
}

/// "26/03 • 14:30" — compact date for cards, where width is scarce.
String formatDayMonthTime(DateTime dt) =>
    '${_two(dt.day)}/${_two(dt.month)} • ${formatTimeOfDay(dt)}';

/// "T7, 26/03/2026".
String formatEventDate(DateTime dt) {
  final wd = _weekdayShort[dt.weekday % 7];
  return '$wd, ${_two(dt.day)}/${_two(dt.month)}/${dt.year}';
}

/// "14:30".
String formatTimeOfDay(DateTime dt) => '${_two(dt.hour)}:${_two(dt.minute)}';

/// "Âm nhạc" / "Âm nhạc +2" / "Sự kiện" — one short label for a list of
/// categories on a small card.
String categoryLabel(List<String> names) {
  final clean = [
    for (final n in names)
      if (n.trim().isNotEmpty) n.trim(),
  ];
  if (clean.isEmpty) return 'Sự kiện';
  if (clean.length == 1) return clean.first;
  return '${clean.first} +${clean.length - 1}';
}

String formatCountdown(Duration remaining) {
  if (remaining <= Duration.zero) return 'Hết hạn';
  return '${remaining.inMinutes}:${_two(remaining.inSeconds % 60)}';
}
