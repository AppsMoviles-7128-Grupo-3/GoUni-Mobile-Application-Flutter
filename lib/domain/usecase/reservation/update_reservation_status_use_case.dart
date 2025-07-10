
import 'package:gouni_flutter/domain/model/reservation_status.dart';
import 'package:gouni_flutter/domain/repository/reservation_repository.dart';

class UpdateReservationStatusUseCase {
  final ReservationRepository reservationRepository;

  UpdateReservationStatusUseCase(this.reservationRepository);

  Future<Result<void>> call(String reservationId, ReservationStatus status) {
    return reservationRepository.updateReservationStatus(reservationId, status);
  }
}