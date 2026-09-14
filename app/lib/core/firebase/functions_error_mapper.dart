import 'package:cloud_functions/cloud_functions.dart';

import '../result/app_exception.dart';

AppException mapFunctionsException(FirebaseFunctionsException e) =>
    mapFunctionsError(e.code, e.message, e.details);

AppException mapFunctionsError(String code, String? message, Object? details) {
  final businessCode = switch (details) {
    {'code': final String value} => value,
    _ => null,
  };
  return switch (code) {
    'unauthenticated' => const AuthException('Bạn cần đăng nhập.'),
    'permission-denied' => const PermissionException(),
    'unavailable' || 'deadline-exceeded' => const NetworkException(),
    'failed-precondition' || 'invalid-argument' => BusinessException(
      message ?? 'Yêu cầu không hợp lệ.',
      code: businessCode ?? 'invalid',
    ),
    _ => ServerException('Functions: $code'),
  };
}
