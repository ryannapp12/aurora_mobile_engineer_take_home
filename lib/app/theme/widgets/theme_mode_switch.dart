import 'package:aurora_mobile_engineer_take_home/app/theme/cubit/theme_cubit.dart';
import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_colors.dart'
    show AppColors;
import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_sizes.dart';
import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_strings.dart';
import 'package:aurora_mobile_engineer_take_home/core/utils/context_extensions.dart';
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
        final bool isDark = context.isDarkTheme;
        // Peek current page palette if needed in future for adaptive tweaks (not used now)
        context.select<RandomImageCubit, Color?>((cubit) {
          final s = cubit.state;
          return s is RandomImageSuccess ? s.primaryColor : null;
        });
        // Use theme-aware glass: darker glass in dark mode, lighter in light mode.
        final Color baseGlass = isDark
            ? AppColors.primary
            : AppColors.secondary;
        final double startA = isDark ? 0.20 : 0.12;
        final double endA = isDark ? 0.12 : 0.08;
        final double borderA = isDark ? 0.30 : 0.18;
        final Color glassStart = baseGlass.withValues(alpha: startA);
        final Color glassEnd = baseGlass.withValues(alpha: endA);
        final Color borderColor = baseGlass.withValues(alpha: borderA);
        final label = isDark ? AppStrings.dark : AppStrings.light;
        final labelColor = isDark ? AppColors.primary : AppColors.secondary;
        final iconColor = isDark ? AppColors.primary : AppColors.secondary;
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
                        color: iconColor,
                      ),
                      SizedBox(width: AppSizes.xs),
                      Text(
                        label,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: labelColor,
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
                            context.read<ThemeCubit>().toggleDark(value);
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
