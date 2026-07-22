import 'package:event_horizon/core/text/search_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const fixtures = {
    'Đêm nhạc Trịnh': 'dem nhac trinh',
    'LỄ HỘI Ánh Sáng': 'le hoi anh sang',
    'Workshop UI/UX': 'workshop ui/ux',
  };

  test('normalizeSearchText khớp contract với titleSearch.ts', () {
    fixtures.forEach((raw, expected) {
      expect(normalizeSearchText(raw), expected);
    });
  });
}
