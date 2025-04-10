class Building {
  final String id;
  final String name;

  Building({required this.id, required this.name});

  factory Building.fromJson(Map<String, dynamic> json) => Building(
        id: json['id'],
        name: json['name'],
      );
}
