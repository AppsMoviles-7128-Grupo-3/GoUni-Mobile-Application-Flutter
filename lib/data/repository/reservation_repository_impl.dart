import 'package:dio/dio.dart';
import 'package:gouni_flutter/data/remote/api/reservation_api.dart';
import 'package:gouni_flutter/data/remote/dto/reservation_dto.dart';
import 'package:gouni_flutter/domain/model/reservation_status.dart';
import 'package:gouni_flutter/domain/model/student_reservation.dart';
import 'package:gouni_flutter/domain/repository/reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationApi reservationApi;

  ReservationRepositoryImpl(this.reservationApi);

  @override
  Stream<List<StudentReservation>> getReservations(String driverId) async* {
    // TODO: debes implementar en el backend la lógica si necesitas
    yield <StudentReservation>[]; 
  }

  @override
  Future<Result<void>> updateReservationStatus(
      String reservationId, ReservationStatus status) async {
    try {
      final response = await reservationApi.updateStatus(
        int.parse(reservationId),
        status.name,
      );
      return Result.success(null); // Asumimos éxito si no hay excepción
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Error al actualizar estado');
    }
  }

  // Opcionales
  Stream<List<StudentReservation>> getReservationsByRoute(String routeId) async* {
    try {
      final response = await reservationApi.getByRouteId(int.parse(routeId));
      final reservations = response.map((dto) => dto.toDomain()).toList();
      yield reservations;
    } catch (_) {
      yield [];
    }
  }

  Stream<List<StudentReservation>> getReservationsByPassenger(String passengerId) async* {
    try {
      final response = await reservationApi.getByPassengerId(int.parse(passengerId));
      final reservations = response.map((dto) => dto.toDomain()).toList();
      yield reservations;
    } catch (_) {
      yield [];
    }
  }

  Future<void> createReservation(StudentReservation reservation) async {
    await reservationApi.create(reservation.toDto());
  }
}

extension ReservationDtoMapper on ReservationDto {
  StudentReservation toDomain() => StudentReservation(
        id: id.toString() ?? '',
        routeId: routeId.toString(),
        studentName: studentName,
        age: age,
        meetingPlace: meetingPlace,
        universityId: universityId,
        profilePhoto: profilePhoto,
        status: ReservationStatus.values.firstWhere(
          (s) => s.name == status,
          orElse: () => ReservationStatus.PENDING,
        ),
      );
}


