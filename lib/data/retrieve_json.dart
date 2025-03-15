import 'dart:convert';
import 'package:campus_clubs/models/club.dart';
import 'package:flutter/services.dart';

class AllClubsFromWeb {
  List<Club> clubs = [];

  Future<void> _populateClubs() async {
    String response = await rootBundle.loadString('lib/data/output.json');
    final List data = await json.decode(response);

    for (final obj in data) {
      List<String> adminEmails = [];

      if (obj["president_email"] != null) {
        adminEmails.add(obj["president_email"]);
      }

      if (obj["advisor_email"] != null) {
        adminEmails.add(obj["advisor_email"]);
      }

      clubs.add(
        Club(
          name: obj["name"],
          description: obj["description"],
          president: obj["president"],
          advisor: obj["advisor"],
          meetingTime: "",
          recommendedTime: "",
          adminEmails: adminEmails,
          adminIDs: [],
        ),
      );
    }
  }

  Future<List<Club>> getClubsFromWeb() async {
    await _populateClubs();
    return clubs;
  }
}
