import 'package:gouni_flutter/domain/repository/auth_repository.dart';

class UpdatePasswordByEmailUseCase {
  final AuthRepository authRepository;

  UpdatePasswordByEmailUseCase(this.authRepository);

  Future<Result<void>> call(String email, String newPassword) {
    return authRepository.updatePasswordByEmail(email, newPassword);
  }
}