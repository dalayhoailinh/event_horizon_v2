import 'package:event_horizon/core/result/app_exception.dart';
import 'package:event_horizon/core/result/failure.dart';
import 'package:event_horizon/core/result/result.dart';
import 'package:event_horizon/features/auth/data/datasources/auth_datasource.dart';
import 'package:event_horizon/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthDatasource extends Mock implements AuthDatasource {}

void main() {
  late _MockAuthDatasource ds;
  late AuthRepositoryImpl repo;

  setUp(() {
    ds = _MockAuthDatasource();
    repo = AuthRepositoryImpl(ds);
  });

  test('login thành công -> Ok', () async {
    when(
      () => ds.loginWithEmail(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});

    final result = await repo.login(email: 'a@b.c', password: '123456');

    expect(result, isA<Ok<void>>());
  });

  test('ds ném AuthException -> Err(AuthFailure)', () async {
    when(
      () => ds.loginWithEmail(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer(
      (_) => throw const AuthException(
        'Email hoặc mật khẩu không đúng.',
        code: 'invalid-credential',
      ),
    );

    final result = await repo.login(email: 'a@b.c', password: 'sai');

    final failure = (result as Err<void>).failure;
    expect(failure, isA<AuthFailure>());
    expect(failure.message, contains('không đúng'));
  });
}
