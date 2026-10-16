import 'package:event_horizon/core/shell/site_nav.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('siteNavIndexOf', () {
    test('section roots map to their own tab', () {
      expect(siteNavIndexOf('/'), 0);
      expect(siteNavIndexOf('/events'), 1);
      expect(siteNavIndexOf('/my-tickets'), 2);
    });

    test('deeper pages belong to their section, not to home', () {
      expect(siteNavIndexOf('/events/evt005'), 1);
      expect(siteNavIndexOf('/events/evt005/seats'), 1);
      expect(siteNavIndexOf('/my-tickets/bk1'), 2);
    });

    test('pages outside the main nav -> null', () {
      expect(siteNavIndexOf('/pay/bk1'), isNull);
      expect(siteNavIndexOf('/login'), isNull);
      // A path that merely starts with the same letters is not a child.
      expect(siteNavIndexOf('/eventsx'), isNull);
    });
  });

  test('isSiteNavRoot: only the roots get bottom tabs', () {
    expect(isSiteNavRoot('/events'), isTrue);
    expect(isSiteNavRoot('/events/evt005'), isFalse);
  });
}
