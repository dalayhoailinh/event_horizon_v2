import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

enum UserRole { user, organizer, admin, staff }

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String email,
    required String displayName,
    required UserRole role,
    required bool emailVerified,
    @Default('') String photoUrl,
  }) = _AppUser;
}
