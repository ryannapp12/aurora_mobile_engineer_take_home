import 'dart:io';
import 'package:aurora_mobile_engineer_take_home/app/theme/cubit/theme_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/domain/repositories/random_image_repository.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/domain/entities/random_image.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/presentation/cubit/random_image_cubit.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/presentation/view/random_image_page.dart';

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hydrated_tests');
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(dir.path),
    );
  });

  testWidgets('Builds page with fake repository (no network)', (tester) async {
    // Fake repo and palette so no network or heavy IO.
    final repo = _FakeRepo();
    Future<({Color primary, Color secondary})> palette(_, __) async =>
        (primary: const Color(0xFF123456), secondary: const Color(0xFF654321));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<RandomImageCubit>(
            create: (_) =>
                RandomImageCubit(repository: repo, paletteAnalyzer: palette),
          ),
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        ],
        child: const MaterialApp(home: RandomImagePage()),
      ),
    );

    // Page should render.
    expect(find.byType(RandomImagePage), findsOneWidget);
  });
}

class _FakeRepo implements RandomImageRepository {
  @override
  Future<RandomImage> fetchRandomImage() async => const RandomImage(
    url: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
  );
}
