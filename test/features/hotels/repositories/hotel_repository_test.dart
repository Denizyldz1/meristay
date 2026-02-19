import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meristay/features/hotels/domain/entities/hotel.dart';
import 'package:meristay/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:meristay/features/hotels/data/repositories/hotel_repository_impl.dart';

void main() {
  group('HotelRepository', () {
    late HotelRepository repository;

    setUp(() {
      // Şu an Dio zorunlu hale geldi, mock Dio geçiyoruz
      // Gerçek API olmadığı için sadece nesneyi oluşturuyoruz
      // Mock data hala impl içinde olduğu için testler çalışmaya devam eder
      repository = HotelRepositoryImpl(Dio());
    });

    // ---------------------------------------------------------------
    // MOCK DATA TESTLERİ
    // Bu testler gerçek API'ye istek atmaz
    // HotelRepositoryImpl içindeki mock data ile çalışır
    // API geldiğinde bu group silinecek veya aşağıdaki gruba taşınacak
    // ---------------------------------------------------------------
    test('getHotels başarılı döner', () async {
      final hotels = await repository.getHotels();

      expect(hotels, isNotEmpty);
      expect(hotels.first, isA<Hotel>());
    });

    test('getHotelById doğru oteli döner', () async {
      final hotel = await repository.getHotelById(1);

      expect(hotel.id, equals(1));
      expect(hotel.name, equals('Merit Royal Hotel'));
    });

    test('getHotelById bulamazsa exception fırlatır', () async {
      expect(
        () => repository.getHotelById(999),
        throwsStateError,
      );
    });
  });

  // ---------------------------------------------------------------
  // GERÇEK API TESTLERİ — ENTEGRASYON TESTLERİ
  // Bu testler gerçek sunucuya istek atar
  // İnternete ihtiyaç duyar, yavaş çalışır
  // CI/CD pipeline'da çalıştırılmaz — sadece geliştirme sırasında
  // manuel olarak çalıştırmak için: flutter test --tags integration
  // ---------------------------------------------------------------
  group('HotelRepository - Gerçek API', () {
    late HotelRepository repository;

    setUp(() {
      // Gerçek API için gerçek Dio instance'ı oluşturuyoruz
      // baseUrl production veya staging olabilir
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.meristay.com',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      repository = HotelRepositoryImpl(dio);
    });

    // skip: true — bu test normalde atlanır
    // Gerçek API'yi test etmek istediğinde skip'i kaldır
    // veya terminalde: flutter test --tags integration
    test(
      'getHotels gerçek API den döner',
      () async {
        // Gerçek API çağrısı yapılır
        final hotels = await repository.getHotels();

        // Temel kontroller — verinin gelip gelmediği
        expect(hotels, isNotEmpty);
        expect(hotels.first.id, isNotNull);
        expect(hotels.first.name, isNotEmpty);

        // İş kuralı kontrolü — fiyat 0'dan büyük olmalı
        expect(hotels.first.pricePerNight, greaterThan(0));
      },
      skip: 'Gerçek API hazır olduğunda skip kaldır',
      // tags: 'integration' — ileride eklenebilir
    );

    test(
      'getHotelById gerçek API den döner',
      () async {
        // Önce listeyi çek, ilk otelin id'sini al
        // Hardcoded id kullanmak tehlikeli — API'de olmayabilir
        final hotels = await repository.getHotels();
        final firstId = hotels.first.id;

        // O id ile detay çek
        final hotel = await repository.getHotelById(firstId);

        expect(hotel.id, equals(firstId));
        expect(hotel.name, isNotEmpty);
      },
      skip: 'Gerçek API hazır olduğunda skip kaldır',
    );

    test(
      'geçersiz id 404 veya exception fırlatır',
      () async {
        // Gerçek API'de olmayan bir id
        // API'nin nasıl davrandığına göre beklenti değişir:
        // - 404 dönüyorsa DioException fırlatır
        // - Boş liste dönüyorsa StateError fırlatır
        expect(
          () => repository.getHotelById(999999),
          throwsA(isA<Exception>()), // DioException veya StateError
        );
      },
      skip: 'Gerçek API hazır olduğunda skip kaldır',
    );
  });
}