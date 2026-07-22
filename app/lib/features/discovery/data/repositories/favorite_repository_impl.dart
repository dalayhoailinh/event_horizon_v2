import 'package:injectable/injectable.dart';

import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_datasource.dart';

@LazySingleton(as: FavoriteRepository)
class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteDataSource _ds;
  const FavoriteRepositoryImpl(this._ds);

  @override
  Stream<bool> watchIsFavorite(String eventId) => _ds.watchIsFavorite(eventId);

  @override
  Future<Result<void>> setFavorite(String eventId, {required bool value}) =>
      guard(() => _ds.setFavorite(eventId, value: value));
}
