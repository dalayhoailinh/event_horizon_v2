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
