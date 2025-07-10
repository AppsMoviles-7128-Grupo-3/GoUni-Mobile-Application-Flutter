import 'package:gouni_flutter/domain/model/route.dart';
import 'package:gouni_flutter/domain/repository/route_repository.dart';

class CreateRouteUseCase {
  final RouteRepository routeRepository;

  CreateRouteUseCase(this.routeRepository);

  Future<Result<String>> call(Route route) {
    return routeRepository.createRoute(route);
  }
}