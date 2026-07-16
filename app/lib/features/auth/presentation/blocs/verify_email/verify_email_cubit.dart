import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'verify_email_state.dart';

@injectable
class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  final AuthRepository _repo;
  VerifyEmailCubit(this._repo) : super(const VerifyEmailState());

  static const _pollInterval = Duration(seconds: 3);
  Timer? _pollTimer;

  void startWatching() {
    _pollTimer ??= Timer.periodic(_pollInterval, (_) => _poll());
  }

  Future<void> _poll() async {
    await _repo.isEmailVerified();
  }

  Future<void> resend() async {
    emit(state.copyWith(busy: true, message: null));
    final result = await _repo.sendEmailVerification();
    if (isClosed) return;
    final message = switch (result) {
      Ok() => 'Đã gửi lại email xác minh.',
      Err(:final failure) => failure.message,
    };
    emit(state.copyWith(busy: false, message: message));
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }
}
