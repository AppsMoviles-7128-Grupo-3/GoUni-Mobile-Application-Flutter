class ReservationDto {
  final int? id;
  final int routeId;
  final int driverId;
  final int passengerId;
  final String? studentName;
  final int? age;
  final String? meetingPlace;
  final String? universityId;
  final String? profilePhoto;
  final String? status;
  
  ReservationDto({
    this.id,
    required this.routeId,
    required this.driverId,
    required this.passengerId,
    this.studentName,
    this.age,
    this.meetingPlace,
    this.universityId,
    this.profilePhoto,
    this.status,
  });

  factory ReservationDto.fromJson(Map<String, dynamic> json) {
    return ReservationDto(
      id: json['id'],
      routeId: json['routeId'],
      driverId: json['driverId'],
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
      if (id != null) 'id': id,
      'routeId': routeId,
      'driverId': driverId,
      'passengerId': passengerId,
      if (studentName != null) 'studentName': studentName,
      if (age != null) 'age': age,
      if (meetingPlace != null) 'meetingPlace': meetingPlace,
      if (universityId != null) 'universityId': universityId,
      if (profilePhoto != null) 'profilePhoto': profilePhoto,
      if (status != null) 'status': status,
    };
  }
}
