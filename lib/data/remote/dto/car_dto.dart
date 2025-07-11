class CarDto {
  final int id;
  final int userId;
  final String make;
  final String model;
  final String licensePlate;
  final String color;
  final int year;
  final String insuranceInfo;
  final String insuranceBrand;
  final String registrationNumber;

  CarDto({
    required this.id,
    required this.userId,
    required this.make,
    required this.model,
    required this.licensePlate,
    required this.color,
    required this.year,
    required this.insuranceInfo,
    required this.insuranceBrand,
    required this.registrationNumber,
  });

  factory CarDto.fromJson(Map<String, dynamic> json) {
    return CarDto(
      id: json['id'],
      userId: json['userId'],
      make: json['make'],
      model: json['model'],
      licensePlate: json['licensePlate'],
      color: json['color'],
      year: json['year'],
      insuranceInfo: json['insuranceInfo'],
      insuranceBrand: json['insuranceBrand'],
      registrationNumber: json['registrationNumber'],
    );
  }
}