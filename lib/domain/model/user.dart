class User {
  final String id;
  final String name;
  final String email;
  final String university;
  final String userCode;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.university,
    required this.userCode,
  });

  // Para convertir desde un Map (por ejemplo desde JSON o SQLite)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      university: map['university'],
      userCode: map['userCode'],
    );
  }

  // Para convertir a un Map (por ejemplo para insertarlo en SQLite o serializar)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'university': university,
      'userCode': userCode,
    };
  }
}
