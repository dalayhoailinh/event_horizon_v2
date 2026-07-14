import 'package:event_horizon/core/result/app_exception.dart';
import 'package:event_horizon/core/result/failure.dart';
import 'package:event_horizon/core/result/guard.dart';
import 'package:event_horizon/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('guard', () {
    test('Thành công -> Ok', () async {
      final result = await guard(() async => 7);
      expect(result, isA<Ok<int>>());
    });

    test('NetworkException -> Err(NetworkFailure)', () async {
      final result = await guard<int>(
        () async => throw const NetworkException(),
      );
      expect(result, isA<Err<int>>());
      expect((result as Err<int>).failure, isA<NetworkFailure>());
    });

    test('BusinessException -> Err(BusinessFailure)', () async {
      final result = await guard<void>(
        () async =>
            throw const BusinessException('Hết vé rồi', code: 'sold-out'),
      );
      final failure = (result as Err<void>).failure as BusinessFailure;
      expect(failure.code, 'sold-out');
    });

    test('Lỗi lạ -> Err(UnexpectedFailure)', () async {
      final result = await guard<int>(() async => throw StateError('boom'));
      expect(result, isA<Err<int>>());
      expect((result as Err<int>).failure, isA<UnexpectedFailure>());
    });
  });
}
