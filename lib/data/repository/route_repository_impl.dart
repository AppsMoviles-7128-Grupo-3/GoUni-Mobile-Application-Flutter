import 'package:gouni_flutter/data/remote/api/route_api.dart';
import 'package:gouni_flutter/data/mapper/route_mapper.dart';
import 'package:gouni_flutter/domain/model/route.dart';
import 'package:gouni_flutter/domain/repository/route_repository.dart';

class RouteRepositoryImpl implements RouteRepository {
  final RouteApi api;
  RouteRepositoryImpl(this.api);

  @override
  Future<List<Route>> getAllRoutes() async {
    final dtos = await api.getAll();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Stream<List<Route>> getMyRoutes(String userId) async* {
    final dtos = await api.getByUserId(int.parse(userId));
    yield dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Stream<Route?> getRouteById(String routeId) async* {
    final dto = await api.getById(int.parse(routeId));
    yield dto.toDomain();
  }
}