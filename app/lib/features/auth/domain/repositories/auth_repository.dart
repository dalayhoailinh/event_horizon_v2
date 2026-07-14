import '../../../../core/result/result.dart';
import '../entities/app_user.dart';

abstract interface class AuthRepository {
  Stream<AppUser?> watchCurrentUser();
  Future<Result<void>> register({
    required String email,
    required String password,
    required String displayName,
  });
  Future<Result<void>> login({required String email, required String password});
  Future<Result<void>> loginWithGoogle();
  Future<Result<void>> sendEmailVerification();
  Future<Result<void>> sendPasswordReset({required String email});
  Future<Result<void>> refreshUser();
  Future<Result<bool>> isEmailVerified();
  Future<Result<void>> logout();
}
