import 'package:campus_clubs/models/club.dart';

class User {
  User({
    required this.name,
    required this.userClubs,
  });

  final String name;
  List<Club> userClubs;
}
