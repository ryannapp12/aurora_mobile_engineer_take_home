import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../domain/entities/random_image.dart';
import '../../domain/repositories/random_image_repository.dart';
import '../../../../core/utils/unsplash_url.dart';
import '../../../../core/shared/constants/app_strings.dart';
import '../../../../core/shared/constants/app_colors.dart';

part 'random_image_state.dart';

class RandomImageCubit extends HydratedCubit<RandomImageState> {
  RandomImageCubit({
    required RandomImageRepository repository,
    Future<({Color primary, Color secondary})> Function(
      String previewUrl,
      String originalUrl,
    )?
    paletteAnalyzer,
  }) : _repository = repository,
       _paletteAnalyzer = paletteAnalyzer ?? _defaultPaletteAnalyzer,
       super(const RandomImageInitial());

  final RandomImageRepository _repository;
  RandomImageSuccess? _prefetched;
  final Future<({Color primary, Color secondary})> Function(String, String)
  _paletteAnalyzer;

  Future<RandomImageSuccess> _fetchAndAnalyzeFromApi() async {
    final RandomImage image = await _repository.fetchRandomImage();
    final String optimizedUrl = optimizeUnsplashSquare(image.url);
    final String previewUrl = optimizeUnsplashSquarePreview(image.url);

    final colors = await _paletteAnalyzer(previewUrl, image.url);
    final Color primary = colors.primary;
    final Color secondary = colors.secondary;

    return RandomImageSuccess(
      originalUrl: image.url,
      imageUrl: optimizedUrl,
      previewUrl: previewUrl,
      primaryColor: primary,
      secondaryColor: secondary,
    );
  }

  Future<void> _prefetchNext() async {
    try {
      final next = await _fetchAndAnalyzeFromApi();
      // Warm caches for fast swap
      unawaited(DefaultCacheManager().downloadFile(next.previewUrl));
      unawaited(DefaultCacheManager().downloadFile(next.imageUrl));
      _prefetched = next;
    } catch (_) {
      // Ignore prefetch failures; user flow remains functional
      _prefetched = null;
    }
  }

  Future<void> loadRandomImage() async {
    try {
      // If we have a prefetched image, swap instantly for a snappy feel
      if (_prefetched != null) {
        emit(_prefetched!);
        _prefetched = null;
        // Start prefetching the next one in the background
        // (not awaited to keep UI responsive)
        unawaited(_prefetchNext());
        return;
      }

      emit(const RandomImageLoading());
      final next = await _fetchAndAnalyzeFromApi();
      emit(next);
      unawaited(_prefetchNext());
    } catch (e) {
      emit(RandomImageFailure(message: AppStrings.failedToLoadImage));
    }
  }

  @override
  RandomImageState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['type'] == 'success') {
        return RandomImageSuccess(
          originalUrl: json['originalUrl'] as String,
          imageUrl: json['imageUrl'] as String,
          previewUrl: json['previewUrl'] as String,
          primaryColor: Color(json['primary'] as int),
          secondaryColor: Color(json['secondary'] as int),
        );
      }
    } catch (_) {
      // ignore corrupt cache
    }
    return const RandomImageInitial();
  }

  @override
  Map<String, dynamic>? toJson(RandomImageState state) {
    if (state is RandomImageSuccess) {
      return {
        'type': 'success',
        'originalUrl': state.originalUrl,
        'imageUrl': state.imageUrl,
        'previewUrl': state.previewUrl,
        'primary': state.primaryColor.toARGB32(),
        'secondary': state.secondaryColor.toARGB32(),
      };
    }
    return null;
  }
}

Future<({Color primary, Color secondary})> _defaultPaletteAnalyzer(
  String previewUrl,
  String originalUrl,
) async {
  try {
    final previewProvider = CachedNetworkImageProvider(previewUrl);
    final palette = await PaletteGenerator.fromImageProvider(
      previewProvider,
      maximumColorCount: 20,
      size: const Size(200, 200),
    );
    final primary =
        palette.dominantColor?.color ??
        palette.vibrantColor?.color ??
        palette.mutedColor?.color ??
        Colors.black;
    final secondary =
        palette.lightVibrantColor?.color ??
        palette.darkVibrantColor?.color ??
        palette.lightMutedColor?.color ??
        palette.darkMutedColor?.color ??
        Color.lerp(primary, AppColors.white, 0.2)!;
    return (primary: primary, secondary: secondary);
  } catch (_) {
    final fallbackProvider = CachedNetworkImageProvider(originalUrl);
    final palette = await PaletteGenerator.fromImageProvider(
      fallbackProvider,
      maximumColorCount: 20,
      size: const Size(200, 200),
    );
    final primary =
        palette.dominantColor?.color ??
        palette.vibrantColor?.color ??
        palette.mutedColor?.color ??
        Colors.black;
    final secondary =
        palette.lightVibrantColor?.color ??
        palette.darkVibrantColor?.color ??
        palette.lightMutedColor?.color ??
        palette.darkMutedColor?.color ??
        Color.lerp(primary, AppColors.white, 0.2)!;
    return (primary: primary, secondary: secondary);
  }
}
