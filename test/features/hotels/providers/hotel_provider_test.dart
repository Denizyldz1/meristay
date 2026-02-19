import 'package:flutter_test/flutter_test.dart';
import 'package:meristay/features/hotels/domain/entities/hotel.dart';
import 'package:meristay/features/hotels/presentation/providers/hotel_provider.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('HotelNotifier', () {
    late MockHotelRepository mockRepository;

    setUp(() {
      mockRepository = MockHotelRepository();
    });

    test('başlangıç state HotelInitial olmalı', () {
      when(() => mockRepository.getHotels()).thenAnswer((_) async => []);

      final container = makeContainer(
        overrides: [hotelRepositoryProvider.overrideWithValue(mockRepository)],
      );

      // Container oluşturulduğu an HotelInitial
      expect(container.read(hotelProvider), isA<HotelInitial>());
    });

    test('fetchHotels başarılı — HotelLoaded döner', () async {
      final mockHotels = [
        const Hotel(
          id: 1,
          name: 'Test Hotel',
          city: 'Girne',
          rating: 4.5,
          pricePerNight: 100.0,
          imageUrl: '',
          isAvailable: true,
        ),
      ];

      when(
        () => mockRepository.getHotels(),
      ).thenAnswer((_) async => mockHotels);

      final container = makeContainer(
        overrides: [hotelRepositoryProvider.overrideWithValue(mockRepository)],
      );

      // async işlemin bitmesini bekle
      await container.read(hotelProvider.notifier).fetchHotels();

      expect(container.read(hotelProvider), isA<HotelLoaded>());

      final loadedState = container.read(hotelProvider) as HotelLoaded;
      expect(loadedState.hotels.length, equals(1));
      expect(loadedState.hotels.first.name, equals('Test Hotel'));
    });

    test('fetchHotels hata — HotelError döner', () async {
      when(
        () => mockRepository.getHotels(),
      ).thenThrow(Exception('Bağlantı hatası'));

      final container = makeContainer(
        overrides: [hotelRepositoryProvider.overrideWithValue(mockRepository)],
      );

      await container.read(hotelProvider.notifier).fetchHotels();

      expect(container.read(hotelProvider), isA<HotelError>());

      final errorState = container.read(hotelProvider) as HotelError;
      expect(errorState.message, contains('Bağlantı hatası'));
    });

    test('hata sonrası tekrar fetchHotels çalışır', () async {
      // Önce hata
      when(() => mockRepository.getHotels()).thenThrow(Exception('Hata'));

      final container = makeContainer(
        overrides: [hotelRepositoryProvider.overrideWithValue(mockRepository)],
      );

      await container.read(hotelProvider.notifier).fetchHotels();
      expect(container.read(hotelProvider), isA<HotelError>());

      // Sonra başarı
      when(() => mockRepository.getHotels()).thenAnswer((_) async => []);

      await container.read(hotelProvider.notifier).fetchHotels();
      expect(container.read(hotelProvider), isA<HotelLoaded>());
    });
  });
}
