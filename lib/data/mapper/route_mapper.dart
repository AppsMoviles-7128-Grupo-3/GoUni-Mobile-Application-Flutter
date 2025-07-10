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
        hour: departureTime['hour'],
        minute: departureTime['minute'],
      ),
      arrivalTime: TimeOfDay(
        hour: arrivalTime['hour'],
        minute: arrivalTime['minute'],
      ),
      availableSeats: availableSeats,
      price: price,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}