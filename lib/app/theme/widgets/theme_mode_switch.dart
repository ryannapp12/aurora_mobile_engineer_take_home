import 'package:aurora_mobile_engineer_take_home/app/theme/cubit/theme_cubit.dart';
import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_sizes.dart';
import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_colors.dart';
import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/random_image/presentation/cubit/random_image_cubit.dart';

/// A compact, reusable switch to toggle light/dark theme instantly.
class ThemeModeSwitch extends StatelessWidget {
  const ThemeModeSwitch({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (prev, curr) => prev.themeMode != curr.themeMode,
      builder: (context, state) {
        final themeCubit = context.read<ThemeCubit>();
        final bool isDark = themeCubit.isDark;
        final onSurface = Theme.of(context).colorScheme.onSurface;
        // Peek current page palette to adapt glass tint against very light backgrounds
        final bgPrimary = context.select<RandomImageCubit, Color?>((cubit) {
          final s = cubit.state;
          return s is RandomImageSuccess ? s.primaryColor : null;
        });
        final bool bgIsLight =
            (bgPrimary ?? Theme.of(context).colorScheme.surface)
                .computeLuminance() >
            0.6;
        // If background is light, use darker glass; otherwise use lighter glass
        final Color glassStart = bgIsLight
            ? AppColors.black.withValues(alpha: 0.12)
            : AppColors.white.withValues(alpha: 0.12);
        final Color glassEnd = bgIsLight
            ? AppColors.black.withValues(alpha: 0.08)
            : AppColors.white.withValues(alpha: 0.06);
        final Color borderColor =
            (bgIsLight ? AppColors.black : AppColors.white).withValues(
              alpha: 0.18,
            );
        final label = isDark ? AppStrings.dark : AppStrings.light;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.sm,
            vertical: AppSizes.xs,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [glassStart, glassEnd],
                  ),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        size: 18,
                        color: onSurface,
                      ),
                      SizedBox(width: AppSizes.xs),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: AppSizes.sm),
                      Transform.scale(
                        scale: 0.9,
                        child: Switch.adaptive(
                          value: isDark,
                          onChanged: (value) {
                            HapticFeedback.selectionClick();
                            themeCubit.toggleDark(value);
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
