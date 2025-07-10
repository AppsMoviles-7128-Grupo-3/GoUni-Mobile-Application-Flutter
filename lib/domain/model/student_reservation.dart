import 'package:gouni_flutter/data/remote/dto/reservation_dto.dart';
import 'package:gouni_flutter/domain/model/reservation_status.dart';

class StudentReservation {
  final String id;
  final String routeId;
  final String studentName;
  final int age;
  final String meetingPlace;
  final String universityId;
  final String universityName;
  final String? profilePhoto;
  final ReservationStatus status;

  StudentReservation({
    required this.id,
    required this.routeId,
    required this.studentName,
    required this.age,
    required this.meetingPlace,
    required this.universityId,
    this.universityName = "",
    this.profilePhoto,
    this.status = ReservationStatus.PENDING,
  });
}


extension StudentReservationMapper on StudentReservation {
  ReservationDto toDto() => ReservationDto(
        id: id,
        routeId: int.parse(routeId),
        passengerId: 0, // Ajusta según corresponda
        studentName: studentName,
        age: age,
        meetingPlace: meetingPlace,
        universityId: universityId,
        profilePhoto: profilePhoto,
        status: status.toString(),
      );
}