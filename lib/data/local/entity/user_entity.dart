import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class UserEntity {
  @primaryKey
  final String id;
  final String email;
  final String password;

  UserEntity({
    required this.id,
    required this.email,
    required this.password,
  });
}