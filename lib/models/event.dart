class Event {
  const Event({
    required this.title,
    required this.message,
    required this.currentTime,
    required this.eventDateTime,
  });

  final String title;
  final String message;
  final DateTime currentTime;
  final String eventDateTime;
}
