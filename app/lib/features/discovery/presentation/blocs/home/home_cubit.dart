import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/entities/event_category.dart';
import '../../../domain/entities/event_summary.dart';
import '../../../domain/repositories/discovery_repository.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final DiscoveryRepository _repo;
  HomeCubit(this._repo) : super(HomeState());

  Future<void> load() async {
    final [featured, upcoming, categories] = await Future.wait([
      _repo.featuredEvents(),
      _repo.upcomingEvents(),
      _repo.categories(),
    ]);
    if (isClosed) return;

    final failure = switch ((featured, upcoming, categories)) {
      (Err(:final failure), _, _) => failure,
      (_, Err(:final failure), _) => failure,
      (_, _, Err(:final failure)) => failure,
      _ => null,
    };
    if (failure != null) {
      emit(HomeState(isLoading: false, failure: failure));
      return;
    }
    emit(
      HomeState(
        isLoading: false,
        featured: (featured as Ok<List<EventSummary>>).value,
        upcoming: (upcoming as Ok<List<EventSummary>>).value,
        categories: (categories as Ok<List<EventCategory>>).value,
      ),
    );
  }
}
