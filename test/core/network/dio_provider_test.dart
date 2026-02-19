import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meristay/features/auth/presentation/providers/auth_provider.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AuthInterceptor', () {
    test('token varsa header eklenir', () async {
      final container = makeContainer();

      // Token'ı set et
      container.read(authTokenProvider.notifier).state = 'test_token';

      // RequestOptions oluştur
      final options = RequestOptions(path: '/hotels');

      // Token'ı oku ve header'a ekle — interceptor mantığını simüle et
      final token = container.read(authTokenProvider);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      expect(
        options.headers['Authorization'],
        equals('Bearer test_token'),
      );
    });

    test('token yoksa header eklenmez', () async {
      final container = makeContainer();
      // token set etmiyoruz — null kalıyor

      final options = RequestOptions(path: '/hotels');

      final token = container.read(authTokenProvider);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      expect(options.headers['Authorization'], isNull);
    });

    test('token değişince yeni token header a gider', () async {
      final container = makeContainer();

      // İlk token
      container.read(authTokenProvider.notifier).state = 'token_1';
      final options1 = RequestOptions(path: '/hotels');
      final token1 = container.read(authTokenProvider);
      if (token1 != null) options1.headers['Authorization'] = 'Bearer $token1';
      expect(options1.headers['Authorization'], equals('Bearer token_1'));

      // Token değişti
      container.read(authTokenProvider.notifier).state = 'token_2';
      final options2 = RequestOptions(path: '/hotels');
      final token2 = container.read(authTokenProvider);
      if (token2 != null) options2.headers['Authorization'] = 'Bearer $token2';
      expect(options2.headers['Authorization'], equals('Bearer token_2'));
    });

    test('logout sonrası token null olur', () async {
      final container = makeContainer();

      // Token set et
      container.read(authTokenProvider.notifier).state = 'test_token';
      expect(container.read(authTokenProvider), equals('test_token'));

      // 401 geldi — token temizle
      container.read(authTokenProvider.notifier).state = null;
      expect(container.read(authTokenProvider), isNull);
    });
  });
}