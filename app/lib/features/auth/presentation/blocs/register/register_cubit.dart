import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _repo;
  RegisterCubit(this._repo) : super(const RegisterState());

  Future<void> submit({
    required String displayName,
    required String email,
    required String password,
  }) async {
    if (displayName.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Vui lòng nhập tên hiển thị.'));
      return;
    }
    if (password.length < 6) {
      emit(state.copyWith(errorMessage: 'Mật khẩu tối thiểu 6 ký tự.'));
      return;
    }
    emit(state.copyWith(submitting: true, errorMessage: null));
    final result = await _repo.register(
      email: email.trim(),
      password: password,
      displayName: displayName.trim(),
    );
    if (isClosed) return;
    switch (result) {
      case Ok():
        emit(state.copyWith(submitting: false));
      case Err(:final failure):
        emit(state.copyWith(submitting: false, errorMessage: failure.message));
    }
  }
}
