sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

final class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Không có kết nối mạng. Vui lòng kiểm tra lại.',
  ]);
}

final class AuthException extends AppException {
  final String? code;
  const AuthException(super.message, {this.code});
}

final class PermissionException extends AppException {
  const PermissionException([
    super.message = 'Bạn không có quyền thực hiện hành động này.',
  ]);
}

final class BusinessException extends AppException {
  final String? code;
  const BusinessException(super.message, {this.code});
}

final class ServerException extends AppException {
  const ServerException([
    super.message = 'Đã xảy ra lỗi từ phía máy chủ. Vui lòng thử lại.',
  ]);
}
