import 'package:gouni_flutter/domain/repository/auth_repository.dart';

class EmailExistsUseCase {
  final AuthRepository authRepository;

  EmailExistsUseCase(this.authRepository);

  Future<bool> call(String email) async {
    return await authRepository.emailExists(email);
  }
}