import 'package:flutter/material.dart';
import '../../core/shared/constants/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    final ColorScheme scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          // Brand secondary explicitly set so it isn't derived from seed
          secondary: AppColors.secondary,
          // Strong, tasteful error colors for better contrast on light backgrounds
          error: const Color(0xFFDC2626), // red-700
          onError: Colors.white,
          errorContainer: const Color(
            0xFFEF4444,
          ), // red-500 (solid, not pastel)
          onErrorContainer: Colors.white,
        );
    final base = ThemeData(
      colorScheme: scheme,
      brightness: Brightness.light,
      useMaterial3: true,
    );
    return base.copyWith(
      scaffoldBackgroundColor: base.colorScheme.surface,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: const StadiumBorder(),
        ),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          final c = base.colorScheme.outlineVariant;
          return c.withValues(
            alpha: states.contains(WidgetState.selected) ? 0.0 : 0.2,
          );
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? base.colorScheme.primary.withValues(alpha: 0.30)
              : base.colorScheme.surfaceContainerHigh;
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? base.colorScheme.primary
              : base.colorScheme.onSurfaceVariant;
        }),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  static ThemeData get dark {
    final ColorScheme scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
          secondary: AppColors.secondary,
          // Dark mode: slightly lighter error for readability over dark surfaces
          error: const Color(0xFFF87171), // red-400
          onError: Colors.black,
          errorContainer: const Color(0xFFDC2626), // red-700 strong
          onErrorContainer: Colors.white,
        );
    final base = ThemeData(
      colorScheme: scheme,
      brightness: Brightness.dark,
      useMaterial3: true,
    );
    return base.copyWith(
      scaffoldBackgroundColor: base.colorScheme.surface,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: const StadiumBorder(),
        ),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          final c = base.colorScheme.outlineVariant;
          return c.withValues(
            alpha: states.contains(WidgetState.selected) ? 0.0 : 0.2,
          );
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? base.colorScheme.primary.withValues(alpha: 0.30)
              : base.colorScheme.surfaceContainerHigh;
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? base.colorScheme.primary
              : base.colorScheme.onSurfaceVariant;
        }),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
