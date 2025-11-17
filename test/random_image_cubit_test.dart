import 'package:aurora_mobile_engineer_take_home/features/random_image/domain/entities/random_image.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/domain/repositories/random_image_repository.dart';
import 'package:aurora_mobile_engineer_take_home/features/random_image/presentation/cubit/random_image_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:io';

class _MockRepository extends Mock implements RandomImageRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hydrated_tests');
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(dir.path),
    );
  });
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hydrated_tests');
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(dir.path),
    );
  });

  late _MockRepository repository;
  late Future<({Color primary, Color secondary})> Function(String, String)
  fakePalette;

  setUp(() {
    repository = _MockRepository();
    fakePalette = (_, __) async =>
        (primary: const Color(0xFF123456), secondary: const Color(0xFF654321));
  });

  blocTest<RandomImageCubit, RandomImageState>(
    'emits [Loading, Success] on happy path',
    build: () {
      when(() => repository.fetchRandomImage()).thenAnswer(
        (_) async =>
            const RandomImage(url: 'https://images.unsplash.com/photo-a'),
      );
      return RandomImageCubit(
        repository: repository,
        paletteAnalyzer: fakePalette,
      );
    },
    act: (cubit) => cubit.loadRandomImage(),
    expect: () => [const RandomImageLoading(), isA<RandomImageSuccess>()],
  );

  blocTest<RandomImageCubit, RandomImageState>(
    'emits [Loading, Failure] when repository throws',
    build: () {
      when(() => repository.fetchRandomImage()).thenThrow(Exception('network'));
      return RandomImageCubit(
        repository: repository,
        paletteAnalyzer: fakePalette,
      );
    },
    act: (cubit) => cubit.loadRandomImage(),
    expect: () => [const RandomImageLoading(), isA<RandomImageFailure>()],
  );

  blocTest<RandomImageCubit, RandomImageState>(
    'uses prefetched result for instant second load',
    build: () {
      int calls = 0;
      when(() => repository.fetchRandomImage()).thenAnswer((_) async {
        calls++;
        return RandomImage(url: 'https://images.unsplash.com/photo-$calls');
      });
      return RandomImageCubit(
        repository: repository,
        paletteAnalyzer: fakePalette,
      );
    },
    act: (cubit) async {
      await cubit.loadRandomImage();
      // give time for prefetch
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await cubit.loadRandomImage();
    },
    expect: () => [
      const RandomImageLoading(),
      isA<RandomImageSuccess>(), // first
      isA<RandomImageSuccess>(), // instant from prefetch
    ],
    verify: (_) {
      // at least two repository calls due to initial + prefetch
      verify(
        () => repository.fetchRandomImage(),
      ).called(greaterThanOrEqualTo(2));
    },
  );
}
