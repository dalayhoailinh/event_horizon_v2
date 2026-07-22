import 'package:event_horizon/core/format/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatVnd ngóm hàng nghìn bằng dấu chấm', () {
    expect(formatVnd(0), 'Miễn phí');
    expect(formatVnd(1000), '1.000đ');
    expect(formatVnd(1000000), '1.000.000đ');
  });

  test('formatPriceRange', () {
    expect(formatPriceRange(0, 0), 'Miễn phí');
    expect(formatPriceRange(1000, 1000), '1.000đ');
    expect(formatPriceRange(1000, 2000), 'Từ 1.000đ');
  });

  test('formatEventTime', () {
    expect(
      formatEventTime(DateTime(2026, 7, 12, 19, 30)),
      'CN · 12/07/2026 · 19:30',
    );
  });
}
