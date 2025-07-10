import 'package:dio/dio.dart';
import 'package:gouni_flutter/data/remote/dto/user_dto.dart'; // Adjust the import according to your project structure

class UserApi {
  final Dio _dio;

  UserApi(this._dio);

  Future<UserDto> register(UserDto user, String password) async {
    final response = await _dio.post(
      '/api/users/register',
      data: user.toJson(),
      queryParameters: {'password': password},
    );
    return UserDto.fromJson(response.data);
  }

  Future<UserDto> login(String email, String password) async {
    final response = await _dio.post(
      '/api/users/login',
      queryParameters: {'email': email, 'password': password},
    );
    return UserDto.fromJson(response.data);
  }

  Future<Response> forgotPassword(String email) async {
    return await _dio.get(
      '/api/users/forgot-password',
      queryParameters: {'email': email},
    );
  }

  Future<Response> resetPassword(String email, String newPassword) async {
    return await _dio.post(
      '/api/users/reset-password',
      queryParameters: {'email': email, 'newPassword': newPassword},
    );
  }

  Future<UserDto> edit(int id, UserDto user, {String? password}) async {
    final response = await _dio.put(
      '/api/users/$id',
      data: user.toJson(),
      queryParameters: password != null ? {'password': password} : null,
    );
    return UserDto.fromJson(response.data);
  }

  Future<UserDto> getById(int id) async {
    final response = await _dio.get('/api/users/$id');
    return UserDto.fromJson(response.data);
  }
}