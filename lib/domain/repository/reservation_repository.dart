import 'package:gouni_flutter/domain/model/reservation_status.dart';
import 'package:gouni_flutter/domain/model/student_reservation.dart';


class Result<T> {
  final T? data;
  final String? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => data != null;
  bool get isFailure => error != null;
}

abstract class ReservationRepository {
  Stream<List<StudentReservation>> getReservations(String driverId);

  Future<Result<void>> updateReservationStatus(
    String reservationId,
    ReservationStatus status,
  );
}
