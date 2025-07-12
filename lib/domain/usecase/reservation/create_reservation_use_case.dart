import 'package:gouni_flutter/domain/model/student_reservation.dart';
import 'package:gouni_flutter/domain/repository/reservation_repository.dart';

class CreateReservationUseCase {
  final ReservationRepository reservationRepository;

  CreateReservationUseCase(this.reservationRepository);

  Future<Result<StudentReservation>> call(StudentReservation reservation) {
    return reservationRepository.createReservation(reservation);
  }
}
