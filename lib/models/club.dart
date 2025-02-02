class Club {
  const Club({
    required this.name,
    required this.description,
    required this.president,
    required this.advisor,
  });

  final String name;
  final String description;
  final String president;
  final String advisor;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'president': president,
      'advisor': advisor,
    };
  }
}
