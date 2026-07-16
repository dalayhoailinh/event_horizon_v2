import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repo;
  LoginCubit(this._repo) : super(const LoginState());

  Future<void> loginWithEmail(String email, String password) async {
    emit(
      state.copyWith(submitting: true, errorMessage: null, infoMessage: null),
    );
    _finish(await _repo.login(email: email.trim(), password: password));
  }

  Future<void> loginWithGoogle() async {
    emit(
      state.copyWith(submitting: true, errorMessage: null, infoMessage: null),
    );
    _finish(await _repo.loginWithGoogle());
  }

  Future<void> sendPasswordReset(String email) async {
    final result = await _repo.sendPasswordReset(email: email.trim());
    if (isClosed) return;
    switch (result) {
      case Ok():
        emit(
          state.copyWith(
            submitting: false,
            infoMessage:
                'Đã gửi email đặt lại mật khẩu. Vui lòng kiểm tra hộp thư.',
          ),
        );
      case Err(:final failure):
        emit(state.copyWith(submitting: false, errorMessage: failure.message));
    }
  }

  void _finish(Result<void> result) {
    if (isClosed) return;
    switch (result) {
      case Ok():
        emit(state.copyWith(submitting: false));
      case Err(:final failure):
        emit(state.copyWith(submitting: false, errorMessage: failure.message));
    }
  }
}
