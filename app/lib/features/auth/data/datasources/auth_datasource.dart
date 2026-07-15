import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/app_user.dart';
import '../models/app_user_mapper.dart';
import 'auth_error_mapper.dart';

abstract interface class AuthDatasource {
  Stream<AppUser?> watchCurrentUser();
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });
  Future<void> loginWithEmail({
    required String email,
    required String password,
  });
  Future<void> loginWithGoogle();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String email});
  Future<void> refreshUser();
  Future<bool> isEmailVerified();
  Future<void> logout();
}

@lazySingleton
class AuthDatasourceImpl implements AuthDatasource {
  final FirebaseAuth _auth;
  const AuthDatasourceImpl(this._auth);

  @override
  Stream<AppUser?> watchCurrentUser() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      try {
        return await mapFirebaseUserToAppUser(user);
      } catch (e) {
        return mapFirebaseUserBasic(user);
      }
    });
  }

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(displayName);
      await cred.user?.sendEmailVerification();
      await cred.user?.reload();
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    }
  }

  @override
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    try {
      final provider = GoogleAuthProvider();
      if (kIsWeb) {
        await _auth.signInWithPopup(provider);
      } else {
        await _auth.signInWithProvider(provider);
      }
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    }
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    }
  }

  @override
  Future<void> refreshUser() async {
    try {
      await _auth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthException(e);
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    await user.getIdToken(true);
    return _auth.currentUser?.emailVerified ?? false;
  }

  @override
  Future<void> logout() => _auth.signOut();
}
