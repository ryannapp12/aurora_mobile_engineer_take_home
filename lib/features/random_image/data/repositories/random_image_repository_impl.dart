import 'package:dio/dio.dart';
import '../../../../core/shared/constants/app_config.dart';

import '../../domain/entities/random_image.dart';
import '../../domain/repositories/random_image_repository.dart';
import '../models/random_image_response.dart';

class RandomImageRepositoryImpl implements RandomImageRepository {
  RandomImageRepositoryImpl({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 2),
              receiveTimeout: const Duration(seconds: 4),
              headers: {'Accept': 'application/json'},
            ),
          );

  static const String _baseUrl = AppConfig.apiBaseUrl;

  final Dio _dio;

  @override
  Future<RandomImage> fetchRandomImage() async {
    final response = await _getWithRetry('/image');
    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final parsed = RandomImageResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      return parsed.toEntity();
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'Unexpected status: ${response.statusCode}',
      type: DioExceptionType.badResponse,
    );
  }

  Future<Response<dynamic>> _getWithRetry(
    String path, {
    int maxRetries = 2,
    Duration initialBackoff = const Duration(milliseconds: 250),
  }) async {
    DioException? lastError;
    Duration backoff = initialBackoff;
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final res = await _dio.get(path);
        return res;
      } on DioException catch (e) {
        lastError = e;
        if (attempt == maxRetries) break;
        await Future<void>.delayed(backoff);
        backoff *= 2;
      }
    }
    throw lastError ??
        DioException(
          requestOptions: RequestOptions(path: path),
          error: 'GET $path failed',
        );
  }
}
