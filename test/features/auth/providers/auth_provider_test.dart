import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:meristay/features/auth/domain/entities/user.dart';
import 'package:meristay/features/auth/presentation/providers/auth_provider.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  group('AuthNotifier', () {
    late MockAuthRepository mockRepository;

    // Test için mock user
    const mockUser = User(
      id: 1,
      name: 'Deniz',
      email: 'test@meristay.com',
      token: 'mock_token',
    );

    setUp(() {
      mockRepository = MockAuthRepository();
    });

    test('başlangıç state AuthInitial olmalı', () {
      final container = makeContainer(overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ]);

      expect(container.read(authProvider), isA<AuthInitial>());
    });

    test('login başarılı — AuthSuccess döner', () async {
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => mockUser);

      final container = makeContainer(overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ]);

      await container.read(authProvider.notifier).login(
            'test@meristay.com',
            '123456',
          );

      expect(container.read(authProvider), isA<AuthSuccess>());

      final state = container.read(authProvider) as AuthSuccess;
      expect(state.user.email, equals('test@meristay.com'));
      expect(state.user.token, equals('mock_token'));
    });

    test('login başarılı — token kaydedilir', () async {
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => mockUser);

      final container = makeContainer(overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ]);

      await container.read(authProvider.notifier).login(
            'test@meristay.com',
            '123456',
          );

      // Token provider'a kaydedildi mi?
      expect(container.read(authTokenProvider), equals('mock_token'));
    });

    test('login hatalı — AuthError döner', () async {
      when(() => mockRepository.login(any(), any()))
          .thenThrow(Exception('E-posta veya şifre hatalı'));

      final container = makeContainer(overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ]);

      await container.read(authProvider.notifier).login(
            'yanlis@email.com',
            'yanlis',
          );

      expect(container.read(authProvider), isA<AuthError>());

      final state = container.read(authProvider) as AuthError;
      expect(state.message, contains('E-posta veya şifre hatalı'));
    });

    test('logout — AuthInitial döner ve token temizlenir', () async {
      // Önce login yap
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => mockUser);
      when(() => mockRepository.logout())
          .thenAnswer((_) async {});

      final container = makeContainer(overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ]);

      await container.read(authProvider.notifier).login(
            'test@meristay.com',
            '123456',
          );

      expect(container.read(authProvider), isA<AuthSuccess>());
      expect(container.read(authTokenProvider), equals('mock_token'));

      // Şimdi logout yap
      await container.read(authProvider.notifier).logout();

      expect(container.read(authProvider), isA<AuthInitial>());
      expect(container.read(authTokenProvider), isNull); // Token temizlendi
    });
  });
}