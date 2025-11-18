import 'package:flutter/material.dart';
import '../../core/shared/constants/app_colors.dart';

class AnimatedGradientBackground extends StatelessWidget {
  const AnimatedGradientBackground({
    super.key,
    required this.primary,
    required this.secondary,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOutCubic,
  });

  final Color primary;
  final Color secondary;
  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final colors = [
      primary,
      Color.lerp(primary, secondary, 0.5) ?? primary,
      secondary,
    ];
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      foregroundDecoration: BoxDecoration(
        // Subtle animated overlay helps reduce harsh changes on bright/dark images
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.black.withValues(alpha: 0.04),
            AppColors.black.withValues(alpha: 0.12),
          ],
        ),
      ),
      child: child,
    );
  }
}
