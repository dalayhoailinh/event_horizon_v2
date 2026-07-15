import 'package:injectable/injectable.dart';

import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _ds;
  const AuthRepositoryImpl(this._ds);

  @override
  Stream<AppUser?> watchCurrentUser() => _ds.watchCurrentUser();

  @override
  Future<Result<void>> register({
    required String email,
    required String password,
    required String displayName,
  }) => guard(
    () => _ds.registerWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    ),
  );

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) => guard(() => _ds.loginWithEmail(email: email, password: password));

  @override
  Future<Result<void>> loginWithGoogle() => guard(_ds.loginWithGoogle);

  @override
  Future<Result<void>> sendEmailVerification() =>
      guard(_ds.sendEmailVerification);

  @override
  Future<Result<void>> sendPasswordReset({required String email}) =>
      guard(() => _ds.sendPasswordReset(email: email));

  @override
  Future<Result<void>> refreshUser() => guard(_ds.refreshUser);

  @override
  Future<Result<bool>> isEmailVerified() => guard(_ds.isEmailVerified);

  @override
  Future<Result<void>> logout() => guard(_ds.logout);
}
