class Message {
  const Message({
    required this.username,
    required this.message,
    required this.currentTime,
  });

  final String username;
  final String message;
  final DateTime currentTime;
}
