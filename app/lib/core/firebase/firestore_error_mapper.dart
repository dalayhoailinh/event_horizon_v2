import 'package:cloud_firestore/cloud_firestore.dart';

import '../result/app_exception.dart';

AppException mapFirestoreException(FirebaseException e) => switch (e.code) {
  'permission-denied' => const PermissionException(),
  'unavailable' || 'deadline-exceeded' => const NetworkException(),
  _ => ServerException('Firestore: ${e.code}'),
};
