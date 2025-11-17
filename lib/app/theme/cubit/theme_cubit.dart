import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

/// ThemeCubit controls the current ThemeMode for the app.
/// It is hydrated to persist the selected mode across app launches.
class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system));
  void setThemeMode(ThemeMode mode) {
    if (state.themeMode == mode) return;
    emit(ThemeState(themeMode: mode));
  }
  void toggleDark(bool isDark) {
    setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
  bool get isDark => switch (state.themeMode) {
    ThemeMode.dark => true,
    ThemeMode.light => false,
    ThemeMode.system =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark,
  };
  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    final value = json['theme'] as String?;
    return switch (value) {
      'dark' => const ThemeState(themeMode: ThemeMode.dark),
      'light' => const ThemeState(themeMode: ThemeMode.light),
      'system' => const ThemeState(themeMode: ThemeMode.system),
      _ => const ThemeState(themeMode: ThemeMode.system),
    };
  }
  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    final value = switch (state.themeMode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    return {'theme': value};
  }
}