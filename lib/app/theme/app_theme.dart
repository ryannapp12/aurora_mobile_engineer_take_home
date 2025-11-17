import 'package:flutter/material.dart';
import '../../core/shared/constants/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      brightness: Brightness.light,
      useMaterial3: true,
    );
    return base.copyWith(
      scaffoldBackgroundColor: base.colorScheme.surface,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.secondary,
        brightness: Brightness.dark,
      ),
      brightness: Brightness.dark,
      useMaterial3: true,
    );
    return base.copyWith(
      scaffoldBackgroundColor: base.colorScheme.surface,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}


