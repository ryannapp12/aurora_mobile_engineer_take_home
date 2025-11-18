
import 'package:aurora_mobile_engineer_take_home/app/theme/cubit/theme_cubit.dart';
import 'package:aurora_mobile_engineer_take_home/core/utils/logger_helper.dart';
import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_config.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/data/repositories/random_image_repository_impl.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/domain/repositories/random_image_repository.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/presentation/cubit/random_image_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final GetIt serviceLocator = GetIt.instance;

const String _baseUrl = AppConfig.apiBaseUrl;
Future<void> setupServiceLocator() async {
  LoggerHelper.info('Setting up service locator...');
  // ********************* First-run Keychain Reset *********************
  // Ensure SharedPreferences is available BEFORE we try to use it
  try {
    SharedPreferences prefs;
    if (serviceLocator.isRegistered<SharedPreferences>()) {
      prefs = serviceLocator<SharedPreferences>();
    } else {
      prefs = await SharedPreferences.getInstance();
      serviceLocator.registerSingleton<SharedPreferences>(prefs);
    }
  } catch (e) {
    LoggerHelper.error('First-run reset failed: $e');
  }
  // ********************* Core Services *********************
  if (!serviceLocator.isRegistered<http.Client>()) {
    serviceLocator.registerLazySingleton<http.Client>(() => http.Client());
  }
  if (!serviceLocator.isRegistered<SharedPreferences>()) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    serviceLocator.registerSingleton<SharedPreferences>(prefs);
  }

  // ********************* Dio *********************
  if (!serviceLocator.isRegistered<Dio>()) {
    serviceLocator.registerLazySingleton<Dio>(() => Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 2),
        receiveTimeout: const Duration(seconds: 4),
        headers: {'Accept': 'application/json'},
      ),
    ));
  }


  // ********************* Random Image Repository *********************
  if (!serviceLocator.isRegistered<RandomImageRepository>()) {
    serviceLocator.registerLazySingleton<RandomImageRepository>(() => RandomImageRepositoryImpl(dio: serviceLocator<Dio>()));
  }

  // ********************* Random Image Cubit *********************
  if (!serviceLocator.isRegistered<RandomImageCubit>()) {
    serviceLocator.registerLazySingleton<RandomImageCubit>(() => RandomImageCubit(repository: serviceLocator<RandomImageRepository>()));
  }

  // ********************* Theme Cubit *********************
  if (!serviceLocator.isRegistered<ThemeCubit>()) {
    serviceLocator.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  }
}