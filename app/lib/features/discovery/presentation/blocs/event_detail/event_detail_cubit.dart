import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/repositories/discovery_repository.dart';
import 'event_detail_state.dart';

@injectable
class EventDetailCubit extends Cubit<EventDetailState> {
  final DiscoveryRepository _repo;
  EventDetailCubit(this._repo) : super(const EventDetailState());

  Future<void> load(String eventId) async {
    if (state != const EventDetailState()) emit(const EventDetailState());
    final result = await _repo.eventDetail(eventId);
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        emit(EventDetailState(isLoading: false, detail: value));
      case Err(:final failure):
        emit(EventDetailState(isLoading: false, failure: failure));
    }
  }
}
