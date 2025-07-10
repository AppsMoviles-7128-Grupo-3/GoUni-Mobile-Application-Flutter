
import 'package:gouni_flutter/domain/model/student_reservation.dart';
import 'package:gouni_flutter/domain/repository/reservation_repository.dart';

class GetReservationsUseCase {
  final ReservationRepository reservationRepository;

  GetReservationsUseCase(this.reservationRepository);

  Stream<List<StudentReservation>> call(String driverId) {
    return reservationRepository.getReservations(driverId);
  }
}