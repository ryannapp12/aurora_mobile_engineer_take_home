import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/shared/constants/app_colors.dart';

class GlassActionBar extends StatelessWidget {
  const GlassActionBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(24);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: border,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: border,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.white.withValues(alpha: 0.12),
                  AppColors.white.withValues(alpha: 0.06),
                ],
              ),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}


