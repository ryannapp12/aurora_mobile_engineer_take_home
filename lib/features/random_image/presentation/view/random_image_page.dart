import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/random_image_cubit.dart';
import '../widgets/random_image_view.dart';
import '../../../../app/widgets/animated_gradient_background.dart';

class RandomImagePage extends StatelessWidget {
  const RandomImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RandomImageCubit, RandomImageState>(
      listenWhen: (prev, curr) => curr is RandomImageFailure,
      listener: (context, state) {
        if (state is RandomImageFailure) {
          HapticFeedback.heavyImpact();
        }
      },
      child: BlocBuilder<RandomImageCubit, RandomImageState>(
        builder: (context, state) {
          final surface = Theme.of(context).colorScheme.surface;
          final primary = switch (state) {
            RandomImageSuccess(:final primaryColor) => primaryColor,
            _ => surface,
          };
          final secondary = switch (state) {
            RandomImageSuccess(:final secondaryColor) => secondaryColor,
            _ => surface,
          };
          return AnimatedGradientBackground(
            primary: primary,
            secondary: secondary,
            child: const Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(child: RandomImageView()),
            ),
          );
        },
      ),
    );
  }
}
