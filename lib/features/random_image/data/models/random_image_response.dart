import '../../domain/entities/random_image.dart';

class RandomImageResponse {
  const RandomImageResponse({required this.url});

  final String url;

  factory RandomImageResponse.fromJson(Map<String, dynamic> json) {
    final urlValue = json['url'] as String?;
    if (urlValue == null || urlValue.isEmpty) {
      throw const FormatException('Invalid API response: missing url');
    }
    return RandomImageResponse(url: urlValue);
  }

  RandomImage toEntity() => RandomImage(url: url);
}


