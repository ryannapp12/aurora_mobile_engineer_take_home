import 'package:aurora_mobile_engineer_take_home/app/theme/widgets/theme_mode_switch.dart';
import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_colors.dart';
import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_sizes.dart';
import 'package:aurora_mobile_engineer_take_home/core/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/random_image_cubit.dart';
import 'glass_action_bar_widget.dart';
import 'another_button_widget.dart';
import 'image_square_widget.dart';
import 'loading_square_widget.dart';
import 'error_square_widget.dart';
import '../../../../core/shared/constants/app_strings.dart';

class RandomImageView extends StatelessWidget {
  const RandomImageView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ThemeModeSwitch(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onDoubleTap: () =>
                      context.read<RandomImageCubit>().loadRandomImage(),
                  child: Center(
                    child: BlocBuilder<RandomImageCubit, RandomImageState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (context, state) {
                        final Widget child = switch (state) {
                          RandomImageLoading() => const LoadingSquare(),
                          RandomImageFailure(:final message) => ErrorSquare(
                            message: message,
                          ),
                          RandomImageSuccess(
                            :final imageUrl,
                            :final previewUrl,
                            :final primaryColor,
                            :final originalUrl,
                          ) =>
                            ImageSquare(
                              key: ValueKey(imageUrl),
                              url: imageUrl,
                              previewUrl: previewUrl,
                              originalUrl: originalUrl,
                              glowColor: primaryColor,
                            ),
                          _ => const LoadingSquare(),
                        };
                        // Precache preview to reduce flicker on initial paint and transitions.
                        if (state is RandomImageSuccess) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            final provider = CachedNetworkImageProvider(
                              state.previewUrl,
                            );
                            precacheImage(provider, context);
                          });
                        }
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final fade = FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                            final scale = Tween<double>(
                              begin: 0.98,
                              end: 1.0,
                            ).animate(animation);
                            return ScaleTransition(scale: scale, child: fade);
                          },
                          child: child,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GlassActionBar(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AnotherButton(),
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.unsplashAttribution,
                    style: textTheme.bodySmall?.copyWith(
                      color: context.isDarkTheme
                          ? AppColors.primary
                          : AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
