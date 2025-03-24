import 'package:campus_clubs/data/retrieve_json.dart';
import 'package:campus_clubs/models/club.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadJsonToFS {
  static final fb = FirebaseFirestore.instance;

  static Future<void> upload() async {
    List<Club> allClubs = await AllClubsFromWeb().getClubsFromWeb();

    for (final club in allClubs) {
      await fb.collection('clubs').doc(club.name).set(
        {
          'description': club.description,
          'president': club.president,
          'advisor': club.advisor,
          'meeting_time': '',
          'recommended_time': '',
          'announncements': {},
          'messages': {},
          'events': {},
          'admins_ids': <String>[],
          'admin_emails': club.adminEmails,
          'members': <String>[],
          'notif_enabled_users': <String>[],
        },
      );
    }
  }
}
