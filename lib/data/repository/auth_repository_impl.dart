import 'package:dio/dio.dart';
import 'package:gouni_flutter/data/remote/api/user_api.dart';
import 'package:gouni_flutter/data/remote/dto/user_dto.dart';
import 'package:gouni_flutter/domain/model/user.dart';
import 'package:gouni_flutter/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserApi userApi;
  User? _currentUser;

  AuthRepositoryImpl(this.userApi);

  @override
  Future<Result<User>> login(String email, String password) async {
    print("Intentando login con email: $email y password: $password"); // 👈 Aquí

    try {
      final response = await userApi.login(email, password);
      print("Respuesta del login: ${response?.toJson()}"); // 👈 Aquí

      if (response != null) {
        final user = response.toDomain();
        _currentUser = user;
        return Result.success(user);
      } else {
        return Result.failure("Email o contraseña incorrecta");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        //return Result.failure("Email o contraseña incorrecta");
        print("Error en login: ${e.response?.data}"); // 👈 Aquí
      }
      return Result.failure("Email o contraseña incorrecta");
    }
  }

  @override
  Future<Result<User>> register(
    String name,
    String email,
    String password,
    String university,
    String userCode,
  ) async {
    try {
      final dto = UserDto(
        id: null,
        name: name,
        email: email,
        university: university,
        userCode: userCode,
      );
      final response = await userApi.register(dto, password);

      // 👉 Imprime la respuesta para ver qué devuelve el backend
      print("Respuesta registro: ${response?.toJson()}");

      if (response != null) {
        return Result.success(response.toDomain());
      }
      return Result.failure("Error en el registro");
    } on DioError catch (e) {
      return Result.failure(e.message ?? "Error en el registro");
    }
    
  }

  @override
  Future<Result<User>> updateUser(User user, String password) async {
    try {
      final dto = user.toDto();
      final passwordParam = password.isNotEmpty ? password : null;
      final response = await userApi.edit(int.parse(user.id), dto, password: passwordParam);
      if (response != null) {
        final updated = response.toDomain();
        _currentUser = updated;
        return Result.success(updated);
      }
      return Result.failure("Error al actualizar usuario");
    } on DioError catch (e) {
      return Result.failure(e.message ?? "Error desconocido");
    }
  }

  @override
  Future<User?> getCurrentUser() async => _currentUser;

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  Future<User?> getUserById(String userId) async {
    try {
      final response = await userApi.getById(int.parse(userId));
      return response.toDomain();
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<User?> getUserByIdFlow(String userId) async* {
    try {
      final response = await userApi.getById(int.parse(userId));
      yield response.toDomain();
    } catch (_) {
      yield null;
    }
  }

  @override
  Future<bool> emailExists(String email) async {
    try {
      final response = await userApi.forgotPassword(email);
      final message = response.data?.toString() ?? '';
      return message.contains("Password reset link sent");
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Result<void>> updatePasswordByEmail(String email, String newPassword) async {
    try {
      final response = await userApi.resetPassword(email, newPassword);
      final message = response.data?.toString() ?? '';
      if (message.contains("Password updated successfully")) {
        return Result.success(null);
      } else {
        return Result.failure(message.isEmpty ? "Unknown error" : message);
      }
    } on DioError catch (e) {
      final message = e.response?.data?.toString() ?? e.message ?? "Error desconocido";
      return Result.failure(message);
    }
  }
}

extension UserDtoMapper on UserDto {
  User toDomain() => User(
        id: id?.toString() ?? '',
        name: name,
        email: email,
        university: university,
        userCode: userCode,
      );
}

extension UserMapper on User {
  UserDto toDto() => UserDto(
        id: int.tryParse(id),
        name: name,
        email: email,
        university: university,
        userCode: userCode,
      );
}