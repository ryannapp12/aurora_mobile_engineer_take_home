@Tags(['golden'])
library;

import 'package:aurora_mobile_engineer_take_home/features/random_image/presentation/widgets/loading_square_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hydrated_tests');
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(dir.path),
    );
  });
  testWidgets('LoadingSquare golden', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(width: 240, child: const LoadingSquare()),
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/loading_square.png'),
    );
  });
}
