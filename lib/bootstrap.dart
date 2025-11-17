import 'dart:async';
import 'package:aurora_mobile_engineer_take_home/app/di/service_locator.dart';
import 'package:aurora_mobile_engineer_take_home/app/observer/app_bloc_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Hydrated storage for hydrated 
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );
  // DI
  await setupServiceLocator();
  // Bloc observer
  Bloc.observer = AppBlocObserver();
  runApp(await builder());
}