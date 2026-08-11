import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/repositories/favorite_repository.dart';
import 'favorite_state.dart';

@injectable
class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _repo;
  StreamSubscription<bool>? _sub;
  String _eventId = '';

  FavoriteCubit(this._repo) : super(const FavoriteState());

  void start(String eventId) {
    _eventId = eventId;
    _sub?.cancel();
    _sub = _repo.watchIsFavorite(eventId).listen((value) {
      if (isClosed) return;
      emit(state.copyWith(isFavorite: value));
    });
  }

  Future<void> toggle() async {
    final target = !state.isFavorite;
    final result = await _repo.setFavorite(_eventId, value: target);
    if (isClosed) return;
    if (result case Err(:final failure)) {
      emit(state.copyWith(message: failure.message));
    }
  }

  void messageShown() => emit(state.copyWith(message: null));

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
