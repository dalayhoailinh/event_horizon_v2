import 'package:diacritic/diacritic.dart';

String normalizeSearchText(String input) {
  final collapsed = input.trim().replaceAll(RegExp(r'\s+'), ' ');
  return removeDiacritics(collapsed).toLowerCase();
}
