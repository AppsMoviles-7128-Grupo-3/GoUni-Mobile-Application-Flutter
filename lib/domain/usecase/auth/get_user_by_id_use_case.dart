import 'package:gouni_flutter/domain/model/user.dart';
import 'package:gouni_flutter/domain/repository/auth_repository.dart';

class GetUserByIdUseCase {
  final AuthRepository repository;

  GetUserByIdUseCase(this.repository);

  Stream<User?> call(String userId) {
    return repository.getUserByIdFlow(userId);
  }
}