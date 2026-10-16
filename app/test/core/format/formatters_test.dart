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

  test('formatCountdown', () {
    expect(formatCountdown(const Duration(minutes: 14, seconds: 5)), '14:05');
    expect(formatCountdown(const Duration(seconds: 9)), '0:09');
    expect(formatCountdown(const Duration(seconds: 0)), 'Hết hạn');
    expect(formatCountdown(const Duration(seconds: -1)), 'Hết hạn');
  });

  test('formatDayMonthTime / formatEventDate / formatTimeOfDay', () {
    final dt = DateTime(2026, 3, 7, 9, 5);
    expect(formatDayMonthTime(dt), '07/03 • 09:05');
    expect(formatEventDate(dt), 'T7, 07/03/2026');
    expect(formatTimeOfDay(dt), '09:05');
  });

  test('categoryLabel: tên đầu + số còn lại, bỏ tên rỗng', () {
    expect(categoryLabel(const []), 'Sự kiện');
    expect(categoryLabel(const ['Âm nhạc']), 'Âm nhạc');
    expect(
      categoryLabel(const ['Âm nhạc', ' ', 'Hội thảo', 'Workshop']),
      'Âm nhạc +2',
    );
  });
}
