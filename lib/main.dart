import 'dart:io';

import 'package:aurora_mobile_engineer_take_home/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bootstrap.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Platform-specific UI mode
  if (Platform.isIOS) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  } else if (Platform.isAndroid) {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
  await bootstrap(() async => const App());
}