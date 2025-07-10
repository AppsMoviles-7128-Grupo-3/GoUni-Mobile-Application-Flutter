import 'package:floor/floor.dart';

@Entity(tableName: 'routes')
class RouteEntity {
  final String id;
  final String driverId;
  final String carId;
  final String start;
  final String end;
  final String days;
  final String departureTime;
  final String arrivalTime;
  final int availableSeats;
  final double price;

  RouteEntity({
    required this.id,
    required this.driverId,
    required this.carId,
    required this.start,
    required this.end,
    required this.days,
    required this.departureTime,
    required this.arrivalTime,
    required this.availableSeats,
    required this.price,
  });
}
