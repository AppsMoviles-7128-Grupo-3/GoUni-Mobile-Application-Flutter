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
    try {
      final response = await reservationApi.getByDriverId(int.parse(driverId));
      final reservations = response.map((dto) => dto.toDomain()).toList();
      yield reservations;
    } catch (_) {
      yield <StudentReservation>[];
    }
  }

  @override
  Future<Result<void>> updateReservationStatus(
      String reservationId, ReservationStatus status) async {
    try {
      await reservationApi.updateStatus(
        int.parse(reservationId),
        status.name,
      );
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Error al actualizar estado');
    }
  }

  @override
  Future<Result<StudentReservation>> createReservation(StudentReservation reservation) async {
    try {
      final response = await reservationApi.create(reservation.toDto());
      return Result.success(response.toDomain());
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Error al crear reserva');
    }
  }

  @override
  Future<Result<List<StudentReservation>>> getReservationsByPassenger(int passengerId) async {
    try {
      final response = await reservationApi.getByPassengerId(passengerId);
      final reservations = response.map((dto) => dto.toDomain()).toList();
      return Result.success(reservations);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Error al obtener reservas');
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
}

extension ReservationDtoMapper on ReservationDto {
  StudentReservation toDomain() => StudentReservation(
        id: id,
        routeId: routeId,
        driverId: driverId,
        passengerId: passengerId,
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


