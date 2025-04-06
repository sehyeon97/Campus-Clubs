class Announcement {
  const Announcement({
    required this.title,
    required this.message,
    required this.currentTime,
    required this.author,
  });

  final String title;
  final String message;
  final DateTime currentTime;
  final String author;
}