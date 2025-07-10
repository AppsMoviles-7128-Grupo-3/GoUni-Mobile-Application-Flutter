import 'package:gouni_flutter/domain/model/user.dart';
import 'package:gouni_flutter/domain/repository/auth_repository.dart';

class UpdateUserUseCase {
  final AuthRepository authRepository;

  UpdateUserUseCase(this.authRepository);

  Future<Result<User>> call(User user, String password) {
    return authRepository.updateUser(user, password);
  }
}