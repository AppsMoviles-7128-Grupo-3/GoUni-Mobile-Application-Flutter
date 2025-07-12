import 'package:gouni_flutter/domain/model/student_reservation.dart';
import 'package:gouni_flutter/domain/repository/reservation_repository.dart';

class GetPassengerReservationsUseCase {
  final ReservationRepository reservationRepository;

  GetPassengerReservationsUseCase(this.reservationRepository);

  Future<Result<List<StudentReservation>>> call(int passengerId) {
    return reservationRepository.getReservationsByPassenger(passengerId);
  }
}
