import 'package:gouni_flutter/domain/model/route.dart';
import 'package:gouni_flutter/domain/repository/route_repository.dart';

class GetRouteByIdUseCase {
  final RouteRepository routeRepository;

  GetRouteByIdUseCase(this.routeRepository);

  Stream<Route?> call(String routeId) {
    return routeRepository.getRouteById(routeId);
  }
}
