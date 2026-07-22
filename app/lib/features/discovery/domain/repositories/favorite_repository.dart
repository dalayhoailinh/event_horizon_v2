import '../../../../core/result/result.dart';

abstract interface class FavoriteRepository {
  Stream<bool> watchIsFavorite(String eventId);
  Future<Result<void>> setFavorite(String eventId, {required bool value});
}
