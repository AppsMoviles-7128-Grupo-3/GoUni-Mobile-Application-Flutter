import 'package:dio/dio.dart';
import 'package:gouni_flutter/data/remote/dto/route_dto.dart';

class RouteApi {
  final Dio _dio;

  RouteApi(this._dio);

  // Crear una ruta
  Future<RouteDto> create(RouteDto route) async {
    final response = await _dio.post(
      '/api/routes',
      data: route.toJson(),
    );
    return RouteDto.fromJson(response.data);
  }

  // Actualizar una ruta
  Future<RouteDto> update(int id, RouteDto route) async {
    final response = await _dio.put(
      '/api/routes/$id',
      data: route.toJson(),
    );
    return RouteDto.fromJson(response.data);
  }

  // Eliminar una ruta
  Future<void> delete(int id) async {
    await _dio.delete('/api/routes/$id');
  }

  // Obtener ruta por ID
  Future<RouteDto> getById(int id) async {
    final response = await _dio.get('/api/routes/$id');
    return RouteDto.fromJson(response.data);
  }

  // Obtener todas las rutas
  Future<List<RouteDto>> getAll() async {
    final response = await _dio.get('/api/routes');
    return (response.data as List)
        .map((json) => RouteDto.fromJson(json))
        .toList();
  }

  // Obtener rutas por ID de conductor
  Future<List<RouteDto>> getByDriverId(int driverId) async {
    final response = await _dio.get('/api/routes/driver/$driverId');
    return (response.data as List)
        .map((json) => RouteDto.fromJson(json))
        .toList();
  }
}