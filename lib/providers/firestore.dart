import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_clubs/models/club.dart';
import 'package:campus_clubs/models/announcement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Firestore {
  static final _fb = FirebaseFirestore.instance;
  static final _fbAuth = FirebaseAuth.instance;

  static Future<void> loginUser(String email, String password) async {
    await _fbAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> createUser(String email, String password) async {
    try {
      final userCredentials = await _fbAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final snapshot = await _fb.collection('clubs').get();
      final clubs = snapshot.docs;
      List<String> availableClubs = [];
      for (var club in clubs) {
        availableClubs.add(club.id);
      }

      await _fb.collection('users').doc(userCredentials.user!.uid).set({
        'name': 'Everyone has the same name',
        'email': email,
        'available_clubs': availableClubs,
        'joined_clubs': [],
      });
    } on FirebaseAuthException catch (error) {
      if (kDebugMode) {
        print(error.message ?? 'Authentication failed');
      }
    }
  }

  // return a list of available Clubs
  static Future<List<Club>> loadAvailableClubs() async {
    List<Club> clubs = [];
    final userID = _fbAuth.currentUser!.uid;
    final userData = await _fb.collection('users').doc(userID).get();
    final List usersAvailableClubs = userData.data()!['available_clubs'];

    final allClubs = await _fb.collection('clubs').get();
    for (var doc in allClubs.docs) {
      if (usersAvailableClubs.contains(doc.id)) {
        clubs.add(
          Club(
            name: doc.id,
            description: doc["description"],
            president: doc["president"],
            advisor: doc["advisor"],
            meetingTime: doc["meeting_time"],
            recommendedTime: doc["recommended_time"],
            adminEmails: [],
            adminIDs: [],
          ),
        );
      }
    }

    return clubs;
  }

  // return a list of joined Clubs
  static Future<List<Club>> loadJoinedClubs(String userID) async {
    List<Club> clubs = [];

    final userData = await _fb.collection('users').doc(userID).get();
    final List usersJoinedClubs = userData.data()!['joined_clubs'];

    final allClubs = await _fb.collection('clubs').get();
    for (var doc in allClubs.docs) {
      if (usersJoinedClubs.contains(doc.id)) {
        clubs.add(
          Club(
            name: doc.id,
            description: doc["description"],
            president: doc["president"],
            advisor: doc["advisor"],
            meetingTime: doc["meeting_time"],
            recommendedTime: doc["recommended_time"],
            adminEmails: doc["admin_emails"],
            adminIDs: doc["admin_ids"],
          ),
        );
      }
    }

    return clubs;
  }

  // Load announcements for selected club
  static Future<List<String>> loadAnnouncements(String clubID) async {
    final clubData = await _fb.collection('clubs').doc(clubID).get();
    return clubData.data()!['announcements'];
  }

  // Remove name from user/joined_clubs
  static void removeClub(String clubName, String userID) async {
    final userData = await _fb.collection('users').doc(userID).get();

    List joinedClubs = userData.data()!['joined_clubs'];
    joinedClubs.removeWhere((name) => name == clubName);

    List availableClubs = userData.data()!['available_clubs'];
    availableClubs.add(clubName);

    await _fb.collection('users').doc(userID).set({
      "joined_clubs": joinedClubs,
      "available_clubs": availableClubs,
    }, SetOptions(merge: true));
  }

  // Add name to user/joined_clubs
  static void addClub(String clubName, String userID) async {
    final userData = await _fb.collection('users').doc(userID).get();

    List joinedClubs = userData.data()!['joined_clubs'];
    joinedClubs.add(clubName);

    List availableClubs = userData.data()!['available_clubs'];
    availableClubs.removeWhere((name) => name == clubName);

    await _fb.collection('users').doc(userID).set({
      "joined_clubs": joinedClubs,
      "available_clubs": availableClubs,
    }, SetOptions(merge: true));
  }

  static Future<void> updateAvailableAndJoinedClubs(
      List<Club> available, List<Club> joined, String userID) async {
    List<String> availableClubsNames = [];
    List<String> joinedClubsNames = [];

    for (Club club in available) {
      availableClubsNames.add(club.name);
    }
    for (Club club in joined) {
      joinedClubsNames.add(club.name);
    }

    await _fb.collection('users').doc(userID).set({
      "available_clubs": availableClubsNames,
      "joined_clubs": joinedClubsNames,
    }, SetOptions(merge: true));
  }

  static Future<String> getMeetingTimeFor(String clubName) async {
    final clubData = await _fb.collection('clubs').doc(clubName).get();
    return clubData.data()!['meeting_time'];
  }

  static Future<String> getRecommendedTime(String clubName) async {
    final clubData = await _fb.collection('clubs').doc(clubName).get();
    return clubData.data()!['recommended_time'];
  }

  // is called when current (former) president / advisor wants to transfer
  // ownership to new (replacing) president / advisor
  // they will want to do this after changing emails on CBU Clubs website info
  static void updateAdminList(Club club) async {
    return;
  }

  // Pull up all users and get this user's email using user ID
  // check all clubs and see if this email belongs to one of the clubs
  // if the email matches with the club passed, return true
  static Future<bool> isAdmin(Club club) async {
    final usersData = await _fb.collection('users').get();
    String userEmail = "";

    for (var userData in usersData.docs) {
      final String userID = userData.id;
      if (userID == _fbAuth.currentUser!.uid) {
        userEmail = userData.data()["email"];
      }
    }

    if (userEmail != "") {
      final clubsData = await _fb.collection('clubs').get();
      for (var clubData in clubsData.docs) {
        final Map<String, dynamic> documents = clubData.data();
        List admins = documents["admin_emails"];

        if (admins.contains(userEmail)) {
          return club.name == clubData.id;
        }
      }
    }

    return false;
  }

  static Future<void> createAnnouncementFor(Club club, String announcementTitle, String content) async {
    final authorData = await _fb.collection('users').doc(_fbAuth.currentUser!.uid).get();
    final String author = authorData['name'];

    await _fb
        .collection('clubs')
        .doc(club.name)
        .collection('announcements')
        .doc(announcementTitle)
        .set(
      {
        "message": content,
        "timestamp": DateTime.now(),
        "author": author,
      },
      SetOptions(merge: true),
    );
  }

  static Future<List<Announcement>> getAnnouncements(String clubName) async {
    final fbAnnouncements = await _fb
      .collection('clubs')
      .doc(clubName)
      .collection('announcements')
      .get();

    List<Announcement> res = List<Announcement>.empty(growable: true);

    for (var doc in fbAnnouncements.docs) {
      res.add(Announcement(
        title: doc.id,
        message: doc["body"],
        currentTime: (doc["timestamp"] as Timestamp).toDate(),
        author: doc["author"],
      ));
    }

    return res;
  }
}