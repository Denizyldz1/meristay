import 'package:flutter_test/flutter_test.dart';
import 'package:meristay/features/hotels/domain/entities/hotel.dart';
import 'package:meristay/features/reservations/domain/entities/reservation.dart';
import 'package:meristay/features/reservations/domain/repositories/reservation_repository.dart';
import 'package:meristay/features/reservations/presentation/providers/reservation_provider.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/test_helpers.dart';

class MockReservationRepository extends Mock implements ReservationRepository {}

void main() {
  group('ReservationNotifier', () {
    late MockReservationRepository mockRepository;

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
    final checkOut = DateTime(2025, 6, 3);

    // Mocktail'e Hotel tipini tanıt
    setUpAll(() {
      registerFallbackValue(
        const Hotel(
          id: 0,
          name: '',
          city: '',
          rating: 0,
          pricePerNight: 0,
          imageUrl: '',
          isAvailable: false,
        ),
      );
      registerFallbackValue(DateTime.now());
    });

    setUp(() {
      mockRepository = MockReservationRepository();
    });

    test('başlangıç state ReservationInitial olmalı', () {
      final container = makeContainer(
        overrides: [
          reservationRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      expect(container.read(reservationProvider), isA<ReservationInitial>());
    });

    test('createReservation başarılı — ReservationSuccess döner', () async {
      final mockReservation = Reservation(
        id: 1,
        hotel: mockHotel,
        checkIn: checkIn,
        checkOut: checkOut,
        guestCount: 2,
        totalPrice: 600,
        status: ReservationStatus.confirmed,
      );

      when(
        () => mockRepository.createReservation(
          hotel: any(named: 'hotel'),
          checkIn: any(named: 'checkIn'),
          checkOut: any(named: 'checkOut'),
          guestCount: any(named: 'guestCount'),
        ),
      ).thenAnswer((_) async => mockReservation);

      final container = makeContainer(
        overrides: [
          reservationRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      await container
          .read(reservationProvider.notifier)
          .createReservation(
            hotel: mockHotel,
            checkIn: checkIn,
            checkOut: checkOut,
            guestCount: 2,
          );

      expect(container.read(reservationProvider), isA<ReservationSuccess>());

      final state = container.read(reservationProvider) as ReservationSuccess;
      expect(state.reservation.totalPrice, equals(600));
      expect(state.reservation.status, equals(ReservationStatus.confirmed));
    });

    test('createReservation hata — ReservationError döner', () async {
      when(
        () => mockRepository.createReservation(
          hotel: any(named: 'hotel'),
          checkIn: any(named: 'checkIn'),
          checkOut: any(named: 'checkOut'),
          guestCount: any(named: 'guestCount'),
        ),
      ).thenThrow(Exception('Rezervasyon oluşturulamadı'));

      final container = makeContainer(
        overrides: [
          reservationRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      await container
          .read(reservationProvider.notifier)
          .createReservation(
            hotel: mockHotel,
            checkIn: checkIn,
            checkOut: checkOut,
            guestCount: 2,
          );

      expect(container.read(reservationProvider), isA<ReservationError>());
    });

    test('gece sayısı ve toplam fiyat doğru hesaplanır', () async {
      // 3 gece x 2 misafir x 150 = 900
      final mockReservation = Reservation(
        id: 1,
        hotel: mockHotel,
        checkIn: checkIn,
        checkOut: DateTime(2025, 6, 4), // 3 gece
        guestCount: 2,
        totalPrice: 900,
        status: ReservationStatus.confirmed,
      );

      expect(mockReservation.nightCount, equals(3));
      expect(mockReservation.totalPrice, equals(900));
    });
  });
}
