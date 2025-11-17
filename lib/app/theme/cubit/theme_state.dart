part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState({required this.themeMode});
  final ThemeMode themeMode;
  ThemeState copyWith({ThemeMode? themeMode}) =>
      ThemeState(themeMode: themeMode ?? this.themeMode);
  @override
  List<Object?> get props => [themeMode];
}