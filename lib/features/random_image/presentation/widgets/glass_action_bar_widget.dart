import 'dart:ui';
import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_colors.dart';
import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_sizes.dart';
import 'package:aurora_mobile_engineer_take_home/core/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class GlassActionBar extends StatelessWidget {
  const GlassActionBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkTheme;
    final Color baseGlass = isDark ? AppColors.primary : AppColors.secondary;
    final border = BorderRadius.circular(24);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
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
                  baseGlass.withValues(alpha: isDark ? 0.20 : 0.12),
                  baseGlass.withValues(alpha: isDark ? 0.12 : 0.06),
                ],
              ),
              border: Border.all(
                color: baseGlass.withValues(alpha: isDark ? 0.28 : 0.18),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm3,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
