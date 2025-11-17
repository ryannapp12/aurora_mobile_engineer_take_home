import '../entities/random_image.dart';

abstract class RandomImageRepository {
  Future<RandomImage> fetchRandomImage();
}


