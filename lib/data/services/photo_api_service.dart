import 'package:dio/dio.dart';

import '../models/music_model.dart';

class PhotoApiService {
  PhotoApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://jsonplaceholder.typicode.com',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
            ),
          ) {
    _dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
  }

  final Dio _dio;

  Future<List<MusicModel>> getPhotoTracks({int limit = 12}) async {
    final response = await _dio.get<List<dynamic>>(
      '/photos',
      queryParameters: {'_limit': limit},
    );

    final data = response.data ?? <dynamic>[];

    return data.map((item) {
      final map = item as Map<String, dynamic>;
      return MusicModel(
        id: 'api_${map['id']}',
        title: map['title']?.toString() ?? 'Untitled',
        artist: 'JSONPlaceholder API',
        image: map['thumbnailUrl']?.toString() ?? '',
        url: map['url']?.toString() ?? '',
      );
    }).toList();
  }
}
