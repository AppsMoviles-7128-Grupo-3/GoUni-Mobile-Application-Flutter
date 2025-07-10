class ReservationDto {
  final String id;
  final int routeId;
  final int passengerId;
  final String studentName;
  final int age;
  final String meetingPlace;
  final String universityId;
  final String? profilePhoto;
  final String status;
  
  ReservationDto({
    required this.id,
    required this.routeId,
    required this.passengerId,
    required this.studentName,
    required this.age,
    required this.meetingPlace,
    required this.universityId,
    this.profilePhoto,
    required this.status,
  });

  factory ReservationDto.fromJson(Map<String, dynamic> json) {
    return ReservationDto(
      id: json['id'],
      routeId: json['routeId'],
      passengerId: json['passengerId'],
      studentName: json['studentName'],
      age: json['age'],
      meetingPlace: json['meetingPlace'],
      universityId: json['universityId'],
      profilePhoto: json['profilePhoto'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeId': routeId,
      'passengerId': passengerId,
      'studentName': studentName,
      'age': age,
      'meetingPlace': meetingPlace,
      'universityId': universityId,
      'profilePhoto': profilePhoto,
      'status': status,
    };
  }
}
