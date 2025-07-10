import 'package:gouni_flutter/domain/model/user.dart';
import 'package:gouni_flutter/domain/repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<Result<User>> call(
    String name,
    String email,
    String password,
    String university,
    String userCode,
  ) {
    return authRepository.register(
      name,
      email,
      password,
      university,
      userCode,
    );
  }
}