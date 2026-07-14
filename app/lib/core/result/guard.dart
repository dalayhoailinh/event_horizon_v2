import 'app_exception.dart';
import 'failure.dart';
import 'result.dart';

Future<Result<T>> guard<T>(Future<T> Function() run) async {
  try {
    return Ok(await run());
  } on AppException catch (e) {
    return Err(mapExceptionToFailure(e));
  } catch (_) {
    return const Err(UnexpectedFailure());
  }
}

Failure mapExceptionToFailure(AppException e) => switch (e) {
  NetworkException() => NetworkFailure(e.message),
  AuthException(:final code) => AuthFailure(e.message, code: code),
  PermissionException() => PermissionFailure(e.message),
  BusinessException(:final code) => BusinessFailure(e.message, code: code),
  ServerException() => UnexpectedFailure(e.message),
};
