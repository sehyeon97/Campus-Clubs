import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class UploadJsonToFS {
  static final fb = FirebaseFirestore.instance;

  static Future<void> upload() async {
    String response = await rootBundle.loadString('lib/data/output.json');
    final List data = await json.decode(response);
    print('club length: ${data.length}');

    for (final club in data) {
      await fb.collection('clubs').doc(club['title']).set(
        {
          'description': club['description'],
          'president': club['president'],
          'advisor': club['advisor'],
          'meeting_time': '',
          'recommended_time': '',
          'announncements': {},
          'messages': {},
          'events': {},
          'admins': <String>[],
          'members': <String>[],
          'notif_enabled_users': <String>[],
        },
      );
    }
  }
}
