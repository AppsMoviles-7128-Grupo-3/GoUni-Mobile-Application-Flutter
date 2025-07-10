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
  Future<Result<String>> createRoute(Route route);

  Stream<List<Route>> getMyRoutes(String driverId);

  Future<Result<void>> deleteRoute(String routeId);

  Stream<Route?> getRouteById(String routeId);
}
