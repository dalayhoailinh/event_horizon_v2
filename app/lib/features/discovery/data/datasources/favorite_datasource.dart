import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/firebase/firestore_error_mapper.dart';
import '../../../../core/result/app_exception.dart';

abstract interface class FavoriteDataSource {
  Stream<bool> watchIsFavorite(String eventId);
  Future<void> setFavorite(String eventId, {required bool value});
}

@Singleton(as: FavoriteDataSource)
class FavoriteDataSourceImpl implements FavoriteDataSource {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  const FavoriteDataSourceImpl(this._db, this._auth);

  DocumentReference<Map<String, dynamic>> _ref(String uid, String eventId) =>
      _db.collection('users').doc(uid).collection('favorites').doc(eventId);

  @override
  Stream<bool> watchIsFavorite(String eventId) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(false);
    return _ref(uid, eventId).snapshots().map((snap) => snap.exists);
  }

  @override
  Future<void> setFavorite(String eventId, {required bool value}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw const AuthException('Bạn cần đăng nhập để yêu thích sự kiện.');
    }
    try {
      final ref = _ref(uid, eventId);
      if (value) {
        await ref.set({'createdAt': FieldValue.serverTimestamp()});
      } else {
        await ref.delete();
      }
    } on FirebaseException catch (e) {
      throw mapFirestoreException(e);
    }
  }
}
