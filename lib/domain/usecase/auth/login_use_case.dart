import 'package:gouni_flutter/domain/model/user.dart';
import 'package:gouni_flutter/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<Result<User>> call(String email, String password) {
    return authRepository.login(email, password);
  }
}