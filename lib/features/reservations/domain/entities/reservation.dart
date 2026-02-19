import '../../../hotels/domain/entities/hotel.dart';

class Reservation {
  final int id;
  final Hotel hotel;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guestCount;
  final double totalPrice;
  final ReservationStatus status;

  const Reservation({
    required this.id,
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
    required this.guestCount,
    required this.totalPrice,
    required this.status,
  });

  // Kaç gece hesapla
  int get nightCount => checkOut.difference(checkIn).inDays;
}

enum ReservationStatus { pending, confirmed, cancelled }