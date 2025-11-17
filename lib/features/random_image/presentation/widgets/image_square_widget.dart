import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/shared/constants/app_strings.dart';
import '../../../../core/shared/constants/app_colors.dart';
import 'error_square_widget.dart';

class ImageSquare extends StatelessWidget {
  const ImageSquare({
    super.key,
    required this.url,
    required this.previewUrl,
    required this.originalUrl,
    required this.glowColor,
  });
  final String url;
  final String previewUrl;
  final String originalUrl;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  radius: 0.8,
                  colors: [
                    glowColor.withValues(alpha: 0.20),
                    glowColor.withValues(alpha: 0.04),
                    AppColors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.25),
                  blurRadius: 24,
                  spreadRadius: 0,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Image.network(
                      previewUrl,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                  Semantics(
                    label: AppStrings.randomImageSemantics,
                    image: true,
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 450),
                      placeholderFadeInDuration: const Duration(milliseconds: 200),
                      placeholder: (context, _) => const SizedBox.shrink(),
                      errorWidget: (context, _, __) {
                        // Fallback to original Unsplash URL if proxy variant fails
                        return CachedNetworkImage(
                          imageUrl: originalUrl,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 350),
                          placeholder: (context, _) => const SizedBox.shrink(),
                          errorWidget: (context, __, ___) => const ErrorSquare(
                            message: AppStrings.imageFailedToLoad,
                          ),
                        );
                      },
                    ),
                  ),
                  IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.black.withValues(alpha: 0.06),
                            AppColors.black.withValues(alpha: 0.10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


