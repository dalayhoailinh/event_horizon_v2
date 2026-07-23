import 'package:event_horizon/core/responsive/responsive_grid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('responsiveColumns', () {
    test('dưới 340 -> 1 cột', () {
      expect(responsiveColumns(availableWidth: 300), 1);
    });

    test('số cột tăng khi chiều rộng tăng', () {
      expect(
        responsiveColumns(availableWidth: 700),
        2,
      ); // 700 / 340 = 2.05 -> 2
      expect(
        responsiveColumns(availableWidth: 1100),
        3,
      ); // 1100 / 340 = 3.23 -> 3
    });

    test('số cột không vượt quá max', () {
      expect(
        responsiveColumns(availableWidth: 2000),
        4,
      ); // 2000 / 340 = 5.88 -> 4 (max)
    });

    test('số cột không nhỏ hơn min', () {
      expect(
        responsiveColumns(availableWidth: 10, min: 2),
        2,
      ); // 10 / 340 = 0.029 -> 2 (min)
    });
  });
}
