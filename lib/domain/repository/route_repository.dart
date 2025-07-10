import 'package:gouni_flutter/domain/model/route.dart';

class Result<T> {
  final T? data;
  final String? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => data != null;
  bool get isFailure => error != null;
}


abstract class RouteRepository {
  Future<List<Route>> getAllRoutes();
  Stream<List<Route>> getMyRoutes(String userId);
  Stream<Route?> getRouteById(String routeId);
}
