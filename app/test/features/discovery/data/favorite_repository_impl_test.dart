import 'package:event_horizon/features/discovery/data/datasources/favorite_datasource.dart';
import 'package:event_horizon/features/discovery/data/repositories/favorite_repository_impl.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuth extends Mock implements FirebaseAuth {}

class _MockUser extends Mock implements User {}

void main() {
  test('setFavorite rồi watch thấy true, bỏ thì false', () async {
    final auth = _MockAuth();
    final user = _MockUser();
    when(() => auth.currentUser).thenReturn(user);
    when(() => user.uid).thenReturn('user1');
    final repo = FavoriteRepositoryImpl(
      FavoriteDataSourceImpl(FakeFirebaseFirestore(), auth),
    );

    await repo.setFavorite('evt1', value: true);
    expect(await repo.watchIsFavorite('evt1').first, true);

    await repo.setFavorite('evt1', value: false);
    expect(await repo.watchIsFavorite('evt1').first, false);
  });
}
