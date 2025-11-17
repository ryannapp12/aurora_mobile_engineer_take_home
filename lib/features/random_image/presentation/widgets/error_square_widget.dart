import 'package:flutter/material.dart';
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
    initButtonAnimation(duration: const Duration(milliseconds: 110), scaleDownValue: 0.96);
  }

  void _retry() {
    context.read<RandomImageCubit>().loadRandomImage();
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final button = FilledButton.icon(
      onPressed: () => triggerButtonPress(onComplete: _retry),
      icon: const Icon(Icons.refresh_rounded),
      label: const Text(AppStrings.tryAgain),
    );
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: onSurface.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: onSurface.withValues(alpha: 0.8),
                      ),
                ),
                const SizedBox(height: 12),
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
      ),
    );
  }
}


