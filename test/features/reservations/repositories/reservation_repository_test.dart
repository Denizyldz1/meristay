import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meristay/features/hotels/domain/entities/hotel.dart';
import 'package:meristay/features/reservations/data/repositories/reservation_repository_impl.dart';
import 'package:meristay/features/reservations/domain/entities/reservation.dart';
import 'package:meristay/features/reservations/domain/repositories/reservation_repository.dart';

void main() {
  group('ReservationRepository', () {
    late ReservationRepository repository;

    const mockHotel = Hotel(
      id: 1,
      name: 'Merit Royal',
      city: 'Girne',
      rating: 4.8,
      pricePerNight: 150,
      imageUrl: '',
      isAvailable: true,
    );

    final checkIn = DateTime(2025, 6, 1);
    final checkOut = DateTime(2025, 6, 3); // 2 gece

    setUp(() {
      repository = ReservationRepositoryImpl(Dio());
    });

    test('createReservation Reservation döner', () async {
      final reservation = await repository.createReservation(
        hotel: mockHotel,
        checkIn: checkIn,
        checkOut: checkOut,
        guestCount: 2,
      );

      expect(reservation, isA<Reservation>());
      expect(reservation.status, equals(ReservationStatus.confirmed));
    });

    test('toplam fiyat doğru hesaplanır', () async {
      // 2 gece x 2 misafir x 150 = 600
      final reservation = await repository.createReservation(
        hotel: mockHotel,
        checkIn: checkIn,
        checkOut: checkOut,
        guestCount: 2,
      );

      expect(reservation.totalPrice, equals(600));
    });

    test('gece sayısı doğru hesaplanır', () async {
      final reservation = await repository.createReservation(
        hotel: mockHotel,
        checkIn: checkIn,
        checkOut: checkOut,
        guestCount: 1,
      );

      expect(reservation.nightCount, equals(2));
    });

    test('getReservations boş liste döner', () async {
      final reservations = await repository.getReservations();
      expect(reservations, isA<List<Reservation>>());
    });

    test('farklı misafir sayılarında fiyat doğru hesaplanır', () async {
      final reservation1 = await repository.createReservation(
        hotel: mockHotel,
        checkIn: checkIn,
        checkOut: checkOut,
        guestCount: 1,
      );

      final reservation2 = await repository.createReservation(
        hotel: mockHotel,
        checkIn: checkIn,
        checkOut: checkOut,
        guestCount: 3,
      );

      // 1 misafir: 2 x 1 x 150 = 300
      expect(reservation1.totalPrice, equals(300));
      // 3 misafir: 2 x 3 x 150 = 900
      expect(reservation2.totalPrice, equals(900));
    });

    // Gerçek API testleri
    group('Gerçek API', () {
      late ReservationRepository realRepository;

      setUp(() {
        realRepository = ReservationRepositoryImpl(
          Dio(BaseOptions(baseUrl: 'https://api.meristay.com')),
        );
      });

      test(
        'createReservation gerçek API den döner',
        () async {
          final reservation = await realRepository.createReservation(
            hotel: mockHotel,
            checkIn: checkIn,
            checkOut: checkOut,
            guestCount: 2,
          );
          expect(reservation, isA<Reservation>());
          expect(reservation.status, equals(ReservationStatus.confirmed));
        },
        skip: 'Gerçek API hazır olduğunda skip kaldır',
      );

      test(
        'getReservations gerçek API den döner',
        () async {
          final reservations = await realRepository.getReservations();
          expect(reservations, isA<List<Reservation>>());
        },
        skip: 'Gerçek API hazır olduğunda skip kaldır',
      );
    });
  });
}