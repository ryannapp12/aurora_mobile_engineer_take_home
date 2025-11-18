import 'package:aurora_mobile_engineer_take_home/core/utils/context_extensions.dart';
import 'package:aurora_mobile_engineer_take_home/core/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/animation_utils.dart';
import '../cubit/random_image_cubit.dart';
import '../../../../core/shared/constants/app_strings.dart';

class AnotherButton extends StatefulWidget {
  const AnotherButton({super.key});
  @override
  State<AnotherButton> createState() => _AnotherButtonState();
}

class _AnotherButtonState extends State<AnotherButton>
    with TickerProviderStateMixin, ButtonAnimationMixin<AnotherButton> {
  @override
  void initState() {
    super.initState();
    initButtonAnimation(
      duration: const Duration(milliseconds: 110),
      scaleDownValue: 0.96,
    );
  }

  void _handleTap() {
    context.read<RandomImageCubit>().loadRandomImage();
  }

  @override
  Widget build(BuildContext context) {
    // Hard align button palette with brand tokens:
    // - Light mode: AppColors.primary
    // - Dark mode: AppColors.secondary
    final bool isDark = context.isDarkTheme;
    final Color backgroundColor = isDark
        ? AppColors.primary
        : AppColors.secondary;
    final Color foregroundColor = AppColors.white;

    final button = Semantics(
      label: AppStrings.loadAnotherImage,
      button: true,
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          onPressed: () {
            HapticFeedback.selectionClick();
            triggerButtonPress(onComplete: _handleTap);
          },
          icon: const Icon(Icons.auto_awesome_rounded),
          label: const Text(AppStrings.another),
        ),
      ),
    );

    return AnimationUtils.createAnimatedButton(
      child: button,
      controller: buttonController,
      animation: buttonScale,
      onTap: () {}, // handled via onPressed to keep semantics
    );
  }
}
