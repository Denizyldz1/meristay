import 'package:dio/dio.dart';
import '../../domain/entities/reservation.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../../../hotels/domain/entities/hotel.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  ReservationRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<Reservation> createReservation({
    required Hotel hotel,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guestCount,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final nightCount = checkOut.difference(checkIn).inDays;
    final totalPrice = hotel.pricePerNight * nightCount * guestCount;

    return Reservation(
      id: DateTime.now().millisecondsSinceEpoch,
      hotel: hotel,
      checkIn: checkIn,
      checkOut: checkOut,
      guestCount: guestCount,
      totalPrice: totalPrice,
      status: ReservationStatus.confirmed,
    );
  }

  @override
  Future<List<Reservation>> getReservations() async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }
}