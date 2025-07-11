import 'package:dio/dio.dart';
import 'package:gouni_flutter/data/remote/dto/car_dto.dart';

class CarApi {
  final Dio _dio;
  CarApi(this._dio);

  Future<CarDto> getCarById(int carId) async {
    final response = await _dio.get('/api/cars/$carId');
    print('CarApi.getCarById response: ${response.data}');
    // Si tu backend responde con un objeto directamente:
    if (response.data is Map<String, dynamic>) {
      return CarDto.fromJson(response.data);
    }
    // Si responde con un objeto dentro de una clave, por ejemplo {"car": {...}}
    if (response.data is Map && response.data['car'] != null) {
      return CarDto.fromJson(response.data['car']);
    }
    throw Exception('Respuesta inesperada del backend: ${response.data}');
  }
}