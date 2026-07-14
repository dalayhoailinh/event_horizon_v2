import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      error: AppColors.danger,
    );
    final base = ThemeData.from(colorScheme: scheme, useMaterial3: true);

    return base.copyWith(
      appBarTheme: const AppBarTheme(centerTitle: true),
      textTheme: base.textTheme
          .apply(fontFamily: 'Roboto')
          .copyWith(
            headlineSmall: base.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            titleMedium: base.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      extensions: const [
        AppStatusColors(success: AppColors.success, warning: AppColors.warning),
      ],
    );
  }
}

@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  final Color success;
  final Color warning;

  const AppStatusColors({required this.success, required this.warning});

  @override
  AppStatusColors copyWith({Color? success, Color? warning}) {
    return AppStatusColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}

extension AppStatusColorsX on BuildContext {
  AppStatusColors get statusColors =>
      Theme.of(this).extension<AppStatusColors>()!;
}
