import 'package:aurora_mobile_engineer_take_home/core/utils/logger_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    LoggerHelper.info('Bloc Event: ${bloc.runtimeType} -> $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    LoggerHelper.info('Bloc Change: ${bloc.runtimeType} -> $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    LoggerHelper.error('Bloc Error: ${bloc.runtimeType}', error);
    super.onError(bloc, error, stackTrace);
  }
}
