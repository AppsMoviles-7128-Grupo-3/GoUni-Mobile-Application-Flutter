class RouteDto {
  final int id;
  final String name;
  final String description;

  RouteDto({
    required this.id,
    required this.name,
    required this.description,
  });

  factory RouteDto.fromJson(Map<String, dynamic> json) {
    return RouteDto(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  toDomain() {}
}
