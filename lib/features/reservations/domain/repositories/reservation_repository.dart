import '../entities/reservation.dart';
import '../../../hotels/domain/entities/hotel.dart';

abstract class ReservationRepository {
  Future<Reservation> createReservation({
    required Hotel hotel,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guestCount,
  });
  Future<List<Reservation>> getReservations();
}