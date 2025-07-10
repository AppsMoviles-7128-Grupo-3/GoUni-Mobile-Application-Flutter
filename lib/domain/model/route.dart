import 'package:flutter/material.dart';

class Route {
  final String id;
  final String driverId;
  final String carId;
  final String startLocation;
  final String endLocation;
  final List<String> appWaypoints;
  final TimeOfDay departureTime;
  final TimeOfDay arrivalTime;
  final int availableSeats;
  final double price;


  Route({
    required this.id,
    required this.driverId,
    required this.carId,
    required this.startLocation,
    required this.endLocation,
    required this.appWaypoints,
    required this.departureTime,
    required this.arrivalTime,
    required this.availableSeats,
    required this.price,
  });

  @override
  String toString() {
    return 'Route{id: $id, driverId: $driverId, carId: $carId, startLocation: $startLocation, endLocation: $endLocation, appWaypoints: $appWaypoints, departureTime: $departureTime, arrivalTime: $arrivalTime, availableSeats: $availableSeats, price: $price}';
  }
}