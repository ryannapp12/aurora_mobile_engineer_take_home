part of 'random_image_cubit.dart';

abstract class RandomImageState extends Equatable {
  const RandomImageState();

  @override
  List<Object?> get props => [];
}

class RandomImageInitial extends RandomImageState {
  const RandomImageInitial();
}

class RandomImageLoading extends RandomImageState {
  const RandomImageLoading();
}

class RandomImageSuccess extends RandomImageState {
  const RandomImageSuccess({
    required this.originalUrl,
    required this.imageUrl,
    required this.previewUrl,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final String originalUrl;
  final String imageUrl;
  final String previewUrl;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  List<Object?> get props => [
    originalUrl,
    imageUrl,
    previewUrl,
    primaryColor.toARGB32(),
    secondaryColor.toARGB32(),
  ];
}

class RandomImageFailure extends RandomImageState {
  const RandomImageFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
