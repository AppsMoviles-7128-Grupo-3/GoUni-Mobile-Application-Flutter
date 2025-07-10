import 'package:flutter/material.dart';

class RouteDto {
  final int id;
  final int userId;
  final int carId;
  final String start;
  final String end;
  final List<String> days;
  final Map<String, dynamic> departureTime;
  final Map<String, dynamic> arrivalTime;
  final int availableSeats;
  final double price;
  final String createdAt;
  final String updatedAt;

  RouteDto({
    required this.id,
    required this.userId,
    required this.carId,
    required this.start,
    required this.end,
    required this.days,
    required this.departureTime,
    required this.arrivalTime,
    required this.availableSeats,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RouteDto.fromJson(Map<String, dynamic> json) {
    return RouteDto(
      id: json['id'],
      userId: json['userId'],
      carId: json['carId'],
      start: json['start'],
      end: json['end'],
      days: List<String>.from(json['days']),
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      availableSeats: json['availableSeats'],
      price: (json['price'] as num).toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
