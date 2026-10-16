import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  static ThemeData get light {
    // ColorScheme.light (not fromSeed): fromSeed derives tinted surface
    // containers, which paints every Card lavender. The design wants white
    // cards on a near-white scaffold, exactly the tokens below.
    const scheme = ColorScheme.light(
      primary: AppColors.violet500, // sys.primary
      onPrimary: AppColors.white, // sys.on-primary
      primaryContainer: AppColors.violet100, // sys.primary-container
      onPrimaryContainer: AppColors.violet900,
      secondary: AppColors.orange500, // sys.secondary
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.orange100,
      onSecondaryContainer: AppColors.orange900,
      error: AppColors.red500, // sys.error
      onError: AppColors.white,
      errorContainer: AppColors.red100,
      surface: AppColors.white, // bg.surface
      onSurface: AppColors.gray800, // text.primary
      surfaceContainerHighest: AppColors.gray100, // bg.surface-variant
      onSurfaceVariant: AppColors.gray500, // text.secondary
      outline: AppColors.gray400,
      outlineVariant: AppColors.gray200, // border.default
    );
    final base = ThemeData.from(colorScheme: scheme, useMaterial3: true);
    final fieldRadius = BorderRadius.circular(AppRadius.md);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.gray25, // bg.scaffold
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        shape: Border(bottom: BorderSide(color: AppColors.gray200)),
      ),
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
      cardTheme: CardThemeData(
        color: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.gray200),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.gray200, space: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          side: const BorderSide(color: AppColors.gray200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.gray100,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.smd,
        ),
        border: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: const BorderSide(color: AppColors.violet500, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: const BorderSide(color: AppColors.red500),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: const BorderSide(color: AppColors.red500, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.gray400),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.gray100,
        selectedColor: AppColors.violet500,
        secondarySelectedColor: AppColors.violet500,
        side: BorderSide.none,
        showCheckmark: false,
        labelStyle: base.textTheme.labelLarge?.copyWith(
          color: AppColors.gray800,
        ),
        secondaryLabelStyle: base.textTheme.labelLarge?.copyWith(
          color: AppColors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.violet100,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(base.textTheme.labelSmall),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.gray200),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      extensions: const [
        AppStatusColors(
          success: AppColors.green500,
          successContainer: AppColors.green100,
          warning: AppColors.amber500,
          warningContainer: AppColors.amber100,
        ),
      ],
    );
  }
}

@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;

  const AppStatusColors({
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
  });

  @override
  AppStatusColors copyWith({
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
  }) {
    return AppStatusColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
    );
  }

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
    );
  }
}

extension AppStatusColorsX on BuildContext {
  AppStatusColors get statusColors =>
      Theme.of(this).extension<AppStatusColors>()!;
}
