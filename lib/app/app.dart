import 'package:aurora_mobile_engineer_take_home/app/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/theme/app_theme.dart';
import '../app/di/service_locator.dart';
import '../features/random_image/presentation/cubit/random_image_cubit.dart';
import '../features/random_image/presentation/view/random_image_page.dart';
import '../core/shared/constants/app_strings.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Use service locator to resolve dependencies consistently app-wide.
    final randomImageCubit = serviceLocator<RandomImageCubit>();
    final themeCubit = serviceLocator<ThemeCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<RandomImageCubit>(
          create: (context) => randomImageCubit..ensureFirstImage(),
        ),
        BlocProvider<ThemeCubit>(create: (_) => themeCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: AppStrings.appName,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeState.themeMode,
            home: const RandomImagePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
