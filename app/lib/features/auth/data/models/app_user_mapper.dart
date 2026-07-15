import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';

Future<AppUser> mapFirebaseUserToAppUser(User user) async {
  final token = await user.getIdTokenResult();
  final roleName = token.claims?['role'] as String? ?? 'user';
  return AppUser(
    id: user.uid,
    email: user.email ?? '',
    displayName: user.displayName ?? '',
    role: UserRole.values.asNameMap()[roleName] ?? UserRole.user,
    emailVerified: user.emailVerified,
    photoUrl: user.photoURL ?? '',
  );
}

AppUser mapFirebaseUserBasic(User user) {
  return AppUser(
    id: user.uid,
    email: user.email ?? '',
    displayName: user.displayName ?? '',
    role: UserRole.user,
    emailVerified: user.emailVerified,
    photoUrl: user.photoURL ?? '',
  );
}
