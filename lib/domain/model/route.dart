import 'package:flutter/material.dart';

class Route {
  final int id;
  final int userId;
  final int carId;
  final String start;
  final String end;
  final List<String> days;
  final TimeOfDay departureTime;
  final TimeOfDay arrivalTime;
  final int availableSeats;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;

  Route({
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

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'],
      userId: json['userId'],
      carId: json['carId'],
      start: json['start'],
      end: json['end'],
      days: List<String>.from(json['days']),
      departureTime: TimeOfDay(
        hour: json['departureTime']['hour'],
        minute: json['departureTime']['minute'],
      ),
      arrivalTime: TimeOfDay(
        hour: json['arrivalTime']['hour'],
        minute: json['arrivalTime']['minute'],
      ),
      availableSeats: json['availableSeats'],
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}