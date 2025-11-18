import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_colors.dart';
import 'package:aurora_mobile_engineer_take_home/core/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/animation_utils.dart';
import '../cubit/random_image_cubit.dart';
import '../../../../core/shared/constants/app_strings.dart';

class ErrorSquare extends StatefulWidget {
  const ErrorSquare({super.key, required this.message});
  final String message;

  @override
  State<ErrorSquare> createState() => _ErrorSquareState();
}

class _ErrorSquareState extends State<ErrorSquare>
    with TickerProviderStateMixin, ButtonAnimationMixin<ErrorSquare> {
  @override
  void initState() {
    super.initState();
    initButtonAnimation(
      duration: const Duration(milliseconds: 110),
      scaleDownValue: 0.96,
    );
  }

  void _retry() {
    context.read<RandomImageCubit>().loadRandomImage();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.theme.colorScheme;
    final isDark = context.isDarkTheme;
    final Color glassBase = isDark ? Colors.black : Colors.white;
    final BorderRadius cardRadius = BorderRadius.circular(20);
    final Color glassStart = glassBase.withValues(alpha: isDark ? 0.20 : 0.12);
    final Color glassEnd = glassBase.withValues(alpha: isDark ? 0.12 : 0.08);
    final Color glassBorder = glassBase.withValues(alpha: isDark ? 0.28 : 0.18);
    final Color msgColor = AppColors.textError;
    final button = FilledButton.icon(
      onPressed: () => triggerButtonPress(onComplete: _retry),
      icon: const Icon(Icons.refresh_rounded),
      label: const Text(AppStrings.tryAgain),
      style: FilledButton.styleFrom(
        backgroundColor: scheme.errorContainer,
        foregroundColor: scheme.onErrorContainer,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: cardRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Frosted glass background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [glassStart, glassEnd],
                  ),
                  border: Border.all(color: glassBorder, width: 1),
                  borderRadius: cardRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.20),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
              ),
            ),
            // Subtle error-tinted glow
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: cardRadius,
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.4),
                    radius: 1.0,
                    colors: [
                      scheme.error.withValues(alpha: 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.error.withValues(alpha: 0.14),
                        border: Border.all(
                          color: scheme.error.withValues(alpha: 0.28),
                        ),
                      ),
                      child: Icon(
                        Icons.error_rounded,
                        color: scheme.error,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: msgColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    AnimationUtils.createAnimatedButton(
                      child: button,
                      controller: buttonController,
                      animation: buttonScale,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
