import 'dart:math';

String generateIntentId() {
  final random = Random.secure();
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(
    32,
    (index) => chars[random.nextInt(chars.length)],
  ).join();
}
