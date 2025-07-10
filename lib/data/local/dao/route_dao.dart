import 'package:floor/floor.dart';

import 'package:gouni_flutter/data/local/entity/route_entity.dart';

@dao
abstract class RouteDao {
  @insert
  Future<void> insertRoute(RouteEntity route);

  @update
  Future<void> updateRoute(RouteEntity route);

  @Query('SELECT * FROM routes WHERE id = :id LIMIT 1')
  Future<RouteEntity?> getRouteById(String id);

  @Query('SELECT * FROM routes WHERE driverId = :driverId')
  Future<List<RouteEntity>> getRoutesByDriverId(String driverId);

  @Query('DELETE FROM routes WHERE id = :routeId')
  Future<void> deleteRouteById(String routeId);
}