class Club {
  const Club({
    required this.name,
    required this.description,
    required this.president,
    required this.advisor,
    required this.meetingTime,
    required this.recommendedTime,
  });

  final String name;
  final String description;
  final String president;
  final String advisor;
  final String meetingTime;
  final String recommendedTime;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'president': president,
      'advisor': advisor,
    };
  }
}
