import 'package:gouni_flutter/domain/repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository authRepository;

  LogoutUseCase(this.authRepository);

  Future<void> call() {
    return authRepository.logout();
  }
}