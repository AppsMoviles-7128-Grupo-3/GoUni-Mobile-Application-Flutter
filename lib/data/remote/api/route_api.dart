import 'package:dio/dio.dart';
import 'package:gouni_flutter/data/remote/dto/route_dto.dart';

class RouteApi {
  final Dio _dio;

  RouteApi(this._dio);


  // Obtener ruta por ID
  Future<RouteDto> getById(int id) async {
    final response = await _dio.get('/api/routes/$id');
    return RouteDto.fromJson(response.data);
  }

  // Obtener todas las rutas
  Future<List<RouteDto>> getAll() async {
    final response = await _dio.get('/api/routes');
    // Aquí response.data debe ser una lista
    return (response.data as List)
        .map((json) => RouteDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Obtener rutas por ID de conductor
  Future<List<RouteDto>> getByDriverId(int driverId) async {
    final response = await _dio.get('/api/routes/user/$driverId');
    return (response.data as List)
        .map((json) => RouteDto.fromJson(json))
        .toList();
  }
  // Obtener rutas por ID de usuario
  Future<List<RouteDto>> getByUserId(int userId) async {
  final response = await _dio.get('/api/routes/user/$userId');
  return (response.data as List)
      .map((json) => RouteDto.fromJson(json))
      .toList();
}
}