import 'package:gouni_flutter/data/remote/dto/car_dto.dart';
import 'package:gouni_flutter/domain/model/car.dart';

extension CarDtoMapper on CarDto {
  Car toDomain() {
    return Car(
      id: id,
      userId: userId,
      make: make,
      model: model,
      licensePlate: licensePlate,
      color: color,
      year: year,
      insuranceInfo: insuranceInfo,
      insuranceBrand: insuranceBrand,
      registrationNumber: registrationNumber,
    );
  }
}