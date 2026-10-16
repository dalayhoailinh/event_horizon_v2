abstract final class AppEnv {
  static const bool useEmulator = bool.fromEnvironment('USE_EMULATOR');

  /// Dev aid: render the mobile-app shell (bottom tabs, no footer) inside a
  /// browser, so it can be previewed without an emulator/device.
  static const bool forceAppShell = bool.fromEnvironment('FORCE_APP_SHELL');
}
