import 'package:floor/floor.dart';
import 'package:gouni_flutter/data/local/entity/user_entity.dart';

@dao
abstract class UserDao {
  @insert
  Future<void> insertUser(UserEntity user); // Note: Floor doesn't support OnConflictStrategy.IGNORE directly

  @update
  Future<void> updateUser(UserEntity user);

  @Query('SELECT * FROM users WHERE email = :email AND password = :password LIMIT 1')
  Future<UserEntity?> getUserByCredentials(String email, String password);

  @Query('SELECT * FROM users WHERE email = :email LIMIT 1')
  Future<UserEntity?> getUserByEmail(String email);

  @Query('SELECT * FROM users WHERE id = :id LIMIT 1')
  Future<UserEntity?> getUserById(String id);

  @Query('SELECT * FROM users WHERE id = :id LIMIT 1')
  Stream<UserEntity?> getUserByIdFlow(String id);
}