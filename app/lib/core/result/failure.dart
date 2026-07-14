sealed class Failure {
  final String message;
  const Failure(this.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Không có kết nối mạng. Vui lòng kiểm tra lại.',
  ]);
}

final class AuthFailure extends Failure {
  final String? code;
  const AuthFailure(super.message, {this.code});
}

final class PermissionFailure extends Failure {
  const PermissionFailure([
    super.message = 'Bạn không có quyền thực hiện hành động này.',
  ]);
}

final class ValidationFailure extends Failure {
  final Map<String, String> fieldErrors;
  const ValidationFailure(super.message, {this.fieldErrors = const {}});
}

final class BusinessFailure extends Failure {
  final String? code;
  const BusinessFailure(super.message, {this.code});
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.',
  ]);
}
