import 'package:event_horizon/features/auth/domain/entities/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const user = AppUser(
    id: 'u1',
    email: 'a@b.c',
    displayName: 'An',
    role: UserRole.user,
    emailVerified: false,
  );

  test('== so sánh theo giá trị (freezed sinh)', () {
    const same = AppUser(
      id: 'u1',
      email: 'a@b.c',
      displayName: 'An',
      role: UserRole.user,
      emailVerified: false,
    );
    expect(user, same);
  });

  test('copyWith đổi đúng 1 field, giữ nguyên phần còn lại', () {
    final verified = user.copyWith(emailVerified: true);
    expect(verified.emailVerified, true);
    expect(verified.id, 'u1');
  });
}
