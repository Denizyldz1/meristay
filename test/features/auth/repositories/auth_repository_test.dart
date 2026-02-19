import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meristay/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:meristay/features/auth/domain/entities/user.dart';
import 'package:meristay/features/auth/domain/repositories/auth_repository.dart';

void main() {
  group('AuthRepository', () {
    late AuthRepository repository;

    setUp(() {
      repository = AuthRepositoryImpl(Dio());
    });

    test('login doğru bilgilerle User döner', () async {
      final user = await repository.login('test@meristay.com', '123456');

      expect(user, isA<User>());
      expect(user.email, equals('test@meristay.com'));
      expect(user.token, isNotEmpty);
    });

    test('login yanlış bilgilerle exception fırlatır', () async {
      expect(
        () => repository.login('yanlis@email.com', 'yanlis'),
        throwsA(isA<Exception>()),
      );
    });

    test('logout exception fırlatmaz', () async {
      expect(() => repository.logout(), returnsNormally);
    });

    test('getCurrentUser null döner', () async {
      final user = await repository.getCurrentUser();
      expect(user, isNull);
    });

    // Gerçek API testleri
    group('Gerçek API', () {
      late AuthRepository realRepository;

      setUp(() {
        realRepository = AuthRepositoryImpl(
          Dio(BaseOptions(baseUrl: 'https://api.meristay.com')),
        );
      });

      test(
        'login gerçek API den döner',
        () async {
          final user = await realRepository.login(
            'test@meristay.com',
            '123456',
          );
          expect(user, isA<User>());
          expect(user.token, isNotEmpty);
        },
        skip: 'Gerçek API hazır olduğunda skip kaldır',
      );

      test(
        'yanlış bilgilerle 401 alınır',
        () async {
          expect(
            () => realRepository.login('yanlis@email.com', 'yanlis'),
            throwsA(isA<Exception>()),
          );
        },
        skip: 'Gerçek API hazır olduğunda skip kaldır',
      );
    });
  });
}