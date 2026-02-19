import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.meristay.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // token_provider'dan token'ı oku
        final token = ref.read(authTokenProvider);

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        handler.next(options);
      },

      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          // logout yerine sadece token'ı temizle
          ref.read(authTokenProvider.notifier).state = null;
        }
        handler.next(error);
      },

      onResponse: (response, handler) {
        handler.next(response);
      },
    ),
  );

  return dio;
});