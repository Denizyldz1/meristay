import 'package:flutter_test/flutter_test.dart';
import 'package:meristay/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:meristay/features/hotels/domain/entities/hotel.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  // Tüm FavoritesNotifier testlerini gruplar
  // group — ilgili testleri bir arada tutar, terminalde düzenli görünür
  group('FavoritesNotifier', () {
    // Her testte taze bir mock oluşturmak için late tanımlandı
    // late — kullanılana kadar initialize edilmez
    late MockFavoritesRepository mockRepository;

    // Her testten ÖNCE çalışır — mock'u sıfırlar
    // Böylece testler birbirini etkilemez
    setUp(() {
      mockRepository = MockFavoritesRepository();
    });

    test('başlangıçta favoriler boş — FavoritesLoaded döner', () async {
      // Mock davranışını tanımla:
      // "getFavorites çağrılınca boş liste döndür"
      // Gerçek API çağrısı yapılmaz, biz kontrol ederiz
      when(() => mockRepository.getFavorites()).thenAnswer((_) async => []);

      // Riverpod container oluştur
      // overrides: gerçek favoritesRepositoryProvider yerine mock'u kullan
      final container = makeContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      // fetchFavorites async, bitene kadar bekle
      // await olmasa state henüz loading'de kalır, test yanlış sonuç verir
      await container.read(favoritesProvider.notifier).fetchFavorites();

      // State'i oku
      final state = container.read(favoritesProvider);

      // FavoritesLoaded mi? — doğru state'e geçti mi kontrol et
      expect(state, isA<FavoritesLoaded>());

      // Liste boş mu? — mock boş liste döndürdü, bunu doğrula
      expect((state as FavoritesLoaded).favorites, isEmpty);
    });

    test('addFavorite sonrası otel listede görünür', () async {
      // Test verisini tanımla — gerçek API'ye gerek yok
      const hotel = Hotel(
        id: 1,
        name: 'Merit Royal Hotel',
        city: 'Girne',
        rating: 4.8,
        pricePerNight: 150.0,
        imageUrl: 'https://picsum.photos/400/200',
        isAvailable: true,
      );

      // addToFavorites çağrılınca bir şey yapma (void)
      when(() => mockRepository.addToFavorites(hotel)).thenAnswer((_) async {});

      // addFavorite içinde fetchFavorites çağrılır
      // fetchFavorites getFavorites'i çağırır — bu sefer hotel döndür
      when(
        () => mockRepository.getFavorites(),
      ).thenAnswer((_) async => [hotel]);

      final container = makeContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      // Favori ekle — içinde fetchFavorites de çağrılır
      await container.read(favoritesProvider.notifier).addFavorite(hotel);

      final state = container.read(favoritesProvider);
      expect(state, isA<FavoritesLoaded>());

      // Hotel listede var mı?
      expect((state as FavoritesLoaded).favorites, contains(hotel));
    });

    test('removeFavorite sonrası otel listeden çıkar', () async {
      const hotel = Hotel(
        id: 1,
        name: 'Merit Royal Hotel',
        city: 'Girne',
        rating: 4.8,
        pricePerNight: 150.0,
        imageUrl: 'https://picsum.photos/400/200',
        isAvailable: true,
      );

      // removeFromFavorites çağrılınca bir şey yapma (void)
      when(
        () => mockRepository.removeFromFavorites(hotel),
      ).thenAnswer((_) async {});

      // Silme sonrası getFavorites boş döner
      when(() => mockRepository.getFavorites()).thenAnswer((_) async => []);

      final container = makeContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      await container.read(favoritesProvider.notifier).removerFavorite(hotel);

      final state = container.read(favoritesProvider);
      expect(state, isA<FavoritesLoaded>());

      // Liste boş mu? — hotel silindi mi doğrula
      expect((state as FavoritesLoaded).favorites, isEmpty);
    });
  });
}
