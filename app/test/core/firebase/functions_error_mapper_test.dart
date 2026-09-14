import 'package:event_horizon/core/firebase/functions_error_mapper.dart';
import 'package:event_horizon/core/result/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('failed-precondition + details.code -> BusinessException giữ mã', () {
    final e = mapFunctionsError(
      'failed-precondition',
      ' "VIP" không còn đủ vé.',
      {'code': 'sold-out'},
    );
    expect(e, isA<BusinessException>());
    expect((e as BusinessException).code, 'sold-out');
    expect(e.message, ' "VIP" không còn đủ vé.');
  });

  test('failed-precondition không details -> code invalid', () {
    final e = mapFunctionsError('failed-precondition', null, null);
    expect((e as BusinessException).code, 'invalid');
  });

  test('unavailable -> NetworkException', () {
    expect(
      mapFunctionsError('unavailable', null, null),
      isA<NetworkException>(),
    );
  });

  test('unauthenticated -> AuthException', () {
    expect(
      mapFunctionsError('unauthenticated', null, null),
      isA<AuthException>(),
    );
  });

  test('mã lạ -> ServerException kèm mã để debug', () {
    final e = mapFunctionsError('internal', null, null);
    expect(e, isA<ServerException>());
    expect(e.message, contains('internal'));
  });
}
