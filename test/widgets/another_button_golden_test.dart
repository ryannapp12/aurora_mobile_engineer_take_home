@Tags(['golden'])
library;

import 'package:aurora_mobile_engineer_take_home/app/theme/cubit/theme_cubit.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/domain/entities/random_image.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/domain/repositories/random_image_repository.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/presentation/cubit/random_image_cubit.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/presentation/widgets/another_button_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'dart:io';

class _FakeRepo implements RandomImageRepository {
  @override
  Future<RandomImage> fetchRandomImage() async =>
      const RandomImage(url: 'https://images.unsplash.com/photo-a');
}

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hydrated_tests');
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(dir.path),
    );
  });
  testWidgets('AnotherButton golden', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<RandomImageCubit>(
              create: (_) => RandomImageCubit(
                repository: _FakeRepo(),
                paletteAnalyzer: (_, __) async =>
                    (primary: Colors.blue, secondary: Colors.blueAccent),
              ),
            ),
            BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
          ],
          child: const Scaffold(
            body: Padding(
              padding: EdgeInsets.all(24.0),
              child: AnotherButton(),
            ),
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/another_button.png'),
    );
  });
}
