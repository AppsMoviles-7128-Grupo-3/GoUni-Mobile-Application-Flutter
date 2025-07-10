import 'package:gouni_flutter/domain/model/route.dart';
import 'package:gouni_flutter/domain/repository/route_repository.dart';

class GetMyRoutesUseCase {
  final RouteRepository routeRepository;

  GetMyRoutesUseCase(this.routeRepository);

  Stream<List<Route>> call(String driverId) {
    return routeRepository.getMyRoutes(driverId);
  }
}
