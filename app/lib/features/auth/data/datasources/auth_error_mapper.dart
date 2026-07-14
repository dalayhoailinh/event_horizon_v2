import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/result/app_exception.dart';

AppException mapFirebaseAuthException(FirebaseAuthException e) {
  return switch (e.code) {
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' => const AuthException(
      'Email hoặc mật khẩu không đúng.',
      code: 'invalid-credential',
    ),
    'email-already-in-use' => const AuthException(
      'Email này đã được sử dụng.',
      code: 'email-already-in-use',
    ),
    'week-password' => const AuthException(
      'Mật khẩu quá yếu (tối thiểu 6 ký tự).',
      code: 'weak-password',
    ),
    'invalid-email' => const AuthException(
      'Email không hợp lệ.',
      code: 'invalid-email',
    ),
    'too-many-requests' => const AuthException(
      'Quá nhiều yêu cầu. Vui lòng thử lại sau.',
      code: 'too-many-requests',
    ),
    'popup-closed-by-user' || 'cancelled-popup-request' || 'user-cancelled' =>
      const AuthException('Bạn đã hủy đăng nhập.', code: 'cancelled'),
    'network-request-failed' => const NetworkException(),
    _ => AuthException(
      e.message ?? 'Đã xảy ra lỗi không xác định.',
      code: e.code,
    ),
  };
}
