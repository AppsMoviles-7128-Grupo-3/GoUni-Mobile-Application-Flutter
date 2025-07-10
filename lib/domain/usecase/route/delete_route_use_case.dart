import 'package:gouni_flutter/domain/repository/route_repository.dart';

class DeleteRouteUseCase {
  final RouteRepository routeRepository;

  DeleteRouteUseCase(this.routeRepository);

  Future<Result<void>> call(String routeId) {
    return routeRepository.deleteRoute(routeId);
  }
}
