import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/theme/cubit/theme_cubit.dart';
extension ThemeContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  bool get isDarkTheme =>
      select<ThemeCubit, bool>((c) => c.isDark);
  bool get isDarkThemeNow => read<ThemeCubit>().isDark;
}