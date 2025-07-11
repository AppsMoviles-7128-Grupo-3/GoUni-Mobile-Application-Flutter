import 'package:gouni_flutter/data/remote/dto/route_dto.dart';
import 'package:gouni_flutter/domain/model/route.dart' as domain;
import 'package:flutter/material.dart';

extension RouteDtoMapper on RouteDto {
  domain.Route toDomain() {
    return domain.Route(
      id: id,
      userId: userId,
      carId: carId,
      start: start,
      end: end,
      days: days,
      departureTime: TimeOfDay(
        hour: (departureTime[0] as num).toInt(),
        minute: (departureTime[1] as num).toInt(),
      ),
      arrivalTime: TimeOfDay(
        hour: (arrivalTime[0] as num).toInt(),
        minute: (arrivalTime[1] as num).toInt(),
      ),
      availableSeats: availableSeats,
      price: price,
      createdAt: DateTime(
        (createdAt[0] as num).toInt(),
        (createdAt[1] as num).toInt(),
        (createdAt[2] as num).toInt(),
        (createdAt[3] as num).toInt(),
        (createdAt[4] as num).toInt(),
        (createdAt[5] as num).toInt(),
        (createdAt[6] as num).toInt(),
      ),
      updatedAt: DateTime(
        (updatedAt[0] as num).toInt(),
        (updatedAt[1] as num).toInt(),
        (updatedAt[2] as num).toInt(),
        (updatedAt[3] as num).toInt(),
        (updatedAt[4] as num).toInt(),
        (updatedAt[5] as num).toInt(),
        (updatedAt[6] as num).toInt(),
      ),
    );
  }
}