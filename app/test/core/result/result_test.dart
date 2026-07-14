import 'package:event_horizon/core/result/failure.dart';
import 'package:event_horizon/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Ok mang giá trị ra được bằng pattern matching', () {
      const Result<int> result = Ok(42);

      final text = switch (result) {
        Ok(:final value) => 'Ok: $value',
        Err() => 'Err',
      };
      expect(text, 'Ok: 42');
    });

    test('Err mang Failure ra được, đúng loại con', () {
      const Result<int> result = Err(NetworkFailure());

      final text = switch (result) {
        Ok() => 'ok',
        Err(:final failure) => failure.message,
      };

      expect(text, contains('kết nối mạng'));
    });
  });
}
