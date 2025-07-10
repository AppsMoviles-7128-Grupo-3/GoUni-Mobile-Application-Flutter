import 'package:gouni_flutter/data/remote/dto/reservation_dto.dart';
import 'package:gouni_flutter/domain/model/student_reservation.dart';

extension StudentReservationDtoMapper on StudentReservation {
  ReservationDto toDto() => ReservationDto(
        id: id,
        routeId: int.parse(routeId),
        passengerId: 0, // Ajustar si tienes el ID del pasajero
        studentName: studentName,
        age: age,
        meetingPlace: meetingPlace,
        universityId: universityId,
        profilePhoto: profilePhoto,
        status: status.name,
      );
}