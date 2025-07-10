class UserDto {
  final int? id;
  final String name;
  final String email;
  final String university;
  final String userCode;

  UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.university,
    required this.userCode,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      university: json['university'],
      userCode: json['userCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'university': university,
      'userCode': userCode,
    };
  }
}