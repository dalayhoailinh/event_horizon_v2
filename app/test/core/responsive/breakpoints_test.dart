import 'package:event_horizon/core/responsive/breakpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Breakpoints.of maps width -> WindowSize (boundaries matter)', () {
    test('dưới 600 là compact', () {
      expect(Breakpoints.of(0), equals(WindowSize.compact));
      expect(Breakpoints.of(599), equals(WindowSize.compact));
    });

    test('600-839 là medium', () {
      expect(Breakpoints.of(600), equals(WindowSize.medium));
      expect(Breakpoints.of(839), equals(WindowSize.medium));
    });

    test('840+ là expanded', () {
      expect(Breakpoints.of(840), equals(WindowSize.expanded));
      expect(Breakpoints.of(10000), equals(WindowSize.expanded));
    });

    test('atLeast được so sánh bởi width order', () {
      expect(WindowSize.expanded.atLeast(WindowSize.medium), isTrue);
      expect(WindowSize.medium.atLeast(WindowSize.medium), isTrue);
      expect(WindowSize.compact.atLeast(WindowSize.medium), isFalse);
    });
  });
}
