import 'package:gouni_flutter/domain/model/user.dart';

class Result<T> {
  final T? data;
  final String? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => data != null;
  bool get isFailure => error != null;
}


abstract class AuthRepository {
  Future<Result<User>> login(String email, String password);

  Future<Result<User>> register(
    String name,
    String email,
    String password,
    String university,
    String userCode,
  );

  Future<User?> getCurrentUser();

  Future<Result<User>> updateUser(User user, String password);

  Future<void> logout();

  Future<User?> getUserById(String userId);

  Stream<User?> getUserByIdFlow(String userId);

  Future<bool> emailExists(String email);

  Future<Result<void>> updatePasswordByEmail(String email, String newPassword);
}
