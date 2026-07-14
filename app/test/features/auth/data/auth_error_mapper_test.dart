import 'package:event_horizon/core/result/app_exception.dart';
import 'package:event_horizon/features/auth/data/datasources/auth_error_mapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('wrong-password -> AuthException với thông điệp thân thiện', () {
    final e = mapFirebaseAuthException(
      FirebaseAuthException(code: 'wrong-password'),
    );
    expect(e, isA<AuthException>());
    expect(e.message, contains('Email hoặc mật khẩu không đúng.'));
  });

  test('network-request-failed -> NetworkException', () {
    final e = mapFirebaseAuthException(
      FirebaseAuthException(code: 'network-request-failed'),
    );
    expect(e, isA<NetworkException>());
  });

  test('mã lạ -> AuthException giữ nguyên code để debug', () {
    final e = mapFirebaseAuthException(FirebaseAuthException(code: 'weird'));
    expect((e as AuthException).code, 'weird');
  });
}
