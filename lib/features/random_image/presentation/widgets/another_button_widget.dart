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
    final colorScheme = Theme.of(context).colorScheme;
    // Adapt button contrast based on current background (primary palette color)
    final bgPrimary = context.select<RandomImageCubit, Color?>((cubit) {
      final state = cubit.state;
      return state is RandomImageSuccess ? state.primaryColor : null;
    });
    final bool bgIsLight =
        (bgPrimary ?? colorScheme.surface).computeLuminance() > 0.6;

    final Color backgroundColor = bgIsLight
        ? colorScheme.primary
        : colorScheme.primaryContainer;
    final Color foregroundColor = bgIsLight
        ? colorScheme.onPrimary
        : colorScheme.onPrimaryContainer;

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
