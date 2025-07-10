import 'package:floor/floor.dart';
import 'package:gouni_flutter/data/local/entity/reservation_entity.dart';

@dao
abstract class ReservationDao {
  @insert
  Future<void> insertReservation(ReservationEntity reservation);

  @update
  Future<void> updateReservation(ReservationEntity reservation);

  @Query('SELECT * FROM reservations WHERE id = :id LIMIT 1')
  Future<ReservationEntity?> getReservationById(String id);

  @Query('SELECT * FROM reservations WHERE userId = :userId')
  Future<List<ReservationEntity>> getReservationsByUserId(String userId);

  @Query('SELECT * FROM reservations WHERE routeId = :routeId')
  Future<List<ReservationEntity>> getReservationsByRouteId(String routeId);

  @Query('SELECT * FROM reservations WHERE routeId IN (SELECT id FROM routes WHERE driverId = :driverId)')
  Future<List<ReservationEntity>> getReservationsByDriverId(String driverId);
}