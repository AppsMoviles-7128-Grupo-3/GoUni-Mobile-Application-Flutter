import 'package:floor/floor.dart';

@Entity(tableName: 'reservations')
class ReservationEntity {
  final String id;
  final String routeId;
  final String studentName;
  final int age;
  final String meetingPlace;
  final String universityId;
  final String universityName;
  final String? profilePhoto;
  final String status;

  ReservationEntity({
    required this.id,
    required this.routeId,
    required this.studentName,
    required this.age,
    required this.meetingPlace,
    required this.universityId,
    this.universityName = "",
    this.profilePhoto,
    required this.status,
  });
}