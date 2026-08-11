import 'package:diacritic/diacritic.dart';

String normalizeSearchText(String input) {
  final collapsed = input.trim().replaceAll(RegExp(r'\s+'), ' ');
  return removeDiacritics(collapsed).toLowerCase();
}

const int kMaxSearchPrefix = 30;

String searchPrefix(String input) {
  final normalized = normalizeSearchText(input);
  if (normalized.length <= kMaxSearchPrefix) return normalized;
  return normalized.substring(0, kMaxSearchPrefix);
}
