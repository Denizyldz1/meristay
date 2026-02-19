import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../../domain/entities/reservation.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../../../hotels/domain/entities/hotel.dart';
import '../../data/repositories/reservation_repository_impl.dart';

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  return ReservationRepositoryImpl(ref.read(dioProvider));
});

sealed class ReservationState {}
class ReservationInitial extends ReservationState {}
class ReservationLoading extends ReservationState {}
class ReservationSuccess extends ReservationState {
  final Reservation reservation;
  ReservationSuccess(this.reservation);
}
class ReservationError extends ReservationState {
  final String message;
  ReservationError(this.message);
}

class ReservationNotifier extends Notifier<ReservationState> {
  @override
  ReservationState build() => ReservationInitial();

  Future<void> createReservation({
    required Hotel hotel,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guestCount,
  }) async {
    state = ReservationLoading();
    try {
      final reservation = await ref
          .read(reservationRepositoryProvider)
          .createReservation(
            hotel: hotel,
            checkIn: checkIn,
            checkOut: checkOut,
            guestCount: guestCount,
          );
      state = ReservationSuccess(reservation);
    } catch (e) {
      state = ReservationError(e.toString());
    }
  }
}

final reservationProvider =
    NotifierProvider<ReservationNotifier, ReservationState>(
  ReservationNotifier.new,
);