import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/entities/event_category.dart';
import '../../../domain/entities/event_filter.dart';
import '../../../domain/repositories/discovery_repository.dart';
import 'discovery_list_state.dart';

@injectable
class DiscoveryListCubit extends Cubit<DiscoveryListState> {
  final DiscoveryRepository _repo;
  DiscoveryListCubit(this._repo) : super(const DiscoveryListState());

  Future<void> load({EventFilter? filter}) async {
    final f = filter ?? state.filter;
    final reset = state.copyWith(
      filter: f,
      isLoading: true,
      failure: null,
      events: [],
      cursor: null,
    );
    if (reset != state) emit(reset);
    final page = await _repo.events(f);
    final cats = state.categories.isEmpty
        ? await _repo.categories()
        : state.categories;
    if (isClosed) return;

    switch (page) {
      case Ok(:final value):
        emit(
          state.copyWith(
            events: value.events,
            categories: cats is Ok<List<EventCategory>>
                ? cats.value
                : state.categories,
            isLoading: false,
            cursor: value.next,
          ),
        );
      case Err(:final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }

  Future<void> loadMore() async {
    final cursor = state.cursor;
    if (cursor == null || state.isLoading || state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true, failure: null));
    final result = await _repo.events(state.filter, after: cursor);
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        emit(
          state.copyWith(
            events: [...state.events, ...value.events],
            isLoadingMore: false,
            cursor: value.next,
          ),
        );
      case Err():
        emit(state.copyWith(isLoadingMore: false));
    }
  }

  void applyFilter(EventFilter filter) {
    if (filter == state.filter) return;
    unawaited(load(filter: filter));
  }
}
