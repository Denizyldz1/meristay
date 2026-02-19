import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meristay/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:meristay/features/hotels/domain/entities/hotel.dart';

void main() {
  group('FavoritesRepositoryImpl', () {
    late FavoritesRepositoryImpl repository;

    // Her testte taze repository — önceki test verisi karışmasın
    setUp(() {
      repository = FavoritesRepositoryImpl(Dio());
    });

    test('başlangıçta liste boş', () async {
      final favorites = await repository.getFavorites();
      expect(favorites, isEmpty);
    });

    test('addToFavorites — otel eklenir', () async {
      const hotel = Hotel(
        id: 1,
        name: 'Merit Royal Hotel',
        city: 'Girne',
        rating: 4.8,
        pricePerNight: 150.0,
        imageUrl: 'https://picsum.photos/400/200',
        isAvailable: true,
      );

      await repository.addToFavorites(hotel);
      final favorites = await repository.getFavorites();

      expect(favorites, contains(hotel));
    });

    test('aynı otel iki kez eklenemez', () async {
      const hotel = Hotel(
        id: 1,
        name: 'Merit Royal Hotel',
        city: 'Girne',
        rating: 4.8,
        pricePerNight: 150.0,
        imageUrl: 'https://picsum.photos/400/200',
        isAvailable: true,
      );

      await repository.addToFavorites(hotel);
      await repository.addToFavorites(hotel); // ikinci kez ekle
      final favorites = await repository.getFavorites();

      expect(favorites.length, 1); // sadece bir tane olmalı
    });

    test('removeFromFavorites — otel çıkarılır', () async {
      const hotel = Hotel(
        id: 1,
        name: 'Merit Royal Hotel',
        city: 'Girne',
        rating: 4.8,
        pricePerNight: 150.0,
        imageUrl: 'https://picsum.photos/400/200',
        isAvailable: true,
      );

      await repository.addToFavorites(hotel);
      await repository.removeFromFavorites(hotel);
      final favorites = await repository.getFavorites();

      expect(favorites, isEmpty);
    });

    test('isFavorite — doğru sonuç döner', () async {
      const hotel = Hotel(
        id: 1,
        name: 'Merit Royal Hotel',
        city: 'Girne',
        rating: 4.8,
        pricePerNight: 150.0,
        imageUrl: 'https://picsum.photos/400/200',
        isAvailable: true,
      );

      expect(await repository.isFavorite(hotel.id), false);
      await repository.addToFavorites(hotel);
      expect(await repository.isFavorite(hotel.id), true);
    });
  });
}
