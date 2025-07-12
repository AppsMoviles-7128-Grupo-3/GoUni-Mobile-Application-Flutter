import 'package:gouni_flutter/data/remote/dto/reservation_dto.dart';
import 'package:gouni_flutter/domain/model/reservation_status.dart';

class StudentReservation {
  final int? id;
  final int routeId;
  final int driverId;
  final int passengerId;
  final String? studentName;
  final int? age;
  final String? meetingPlace;
  final String? universityId;
  final String universityName;
  final String? profilePhoto;
  final ReservationStatus status;

  StudentReservation({
    this.id,
    required this.routeId,
    required this.driverId,
    required this.passengerId,
    this.studentName,
    this.age,
    this.meetingPlace,
    this.universityId,
    this.universityName = "",
    this.profilePhoto,
    this.status = ReservationStatus.PENDING,
  });
}


extension StudentReservationMapper on StudentReservation {
  ReservationDto toDto() => ReservationDto(
        id: id,
        routeId: routeId,
        driverId: driverId,
        passengerId: passengerId,
        studentName: studentName,
        age: age,
        meetingPlace: meetingPlace,
        universityId: universityId,
        profilePhoto: profilePhoto,
        status: status.toString(),
      );
}