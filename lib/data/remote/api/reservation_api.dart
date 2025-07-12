import 'package:dio/dio.dart';
import 'package:gouni_flutter/data/remote/dto/reservation_dto.dart';

class ReservationApi {
  final Dio _dio;

  ReservationApi(this._dio);

  // Crear una reserva
  Future<ReservationDto> create(ReservationDto reservation) async {
    final response = await _dio.post(
      '/api/reservations',
      data: reservation.toJson(),
    );
    return ReservationDto.fromJson(response.data);
  }

  // Actualizar estado de la reserva
  Future<ReservationDto> updateStatus(int id, String status) async {
    final response = await _dio.put(
      '/api/reservations/$id/status',
      queryParameters: {'status': status},
    );
    return ReservationDto.fromJson(response.data);
  }

  // Obtener reservas por ID de ruta
  Future<List<ReservationDto>> getByRouteId(int routeId) async {
    final response = await _dio.get('/api/reservations/route/$routeId');
    return (response.data as List)
        .map((json) => ReservationDto.fromJson(json))
        .toList();
  }

  // Obtener reservas por ID de pasajero
  Future<List<ReservationDto>> getByPassengerId(int passengerId) async {
    final response = await _dio.get('/api/reservations/passenger/$passengerId');
    return (response.data as List)
        .map((json) => ReservationDto.fromJson(json))
        .toList();
  }
  
  // Obtener reservas por ID de conductor
  Future<List<ReservationDto>> getByDriverId(int driverId) async {
    final response = await _dio.get('/api/reservations/driver/$driverId');
    return (response.data as List)
        .map((json) => ReservationDto.fromJson(json))
        .toList();
  }
}