import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_clubs/models/club.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Firestore {
  static final fb = FirebaseFirestore.instance;
  static final fbAuth = FirebaseAuth.instance;

  static Future<void> loginUser(String email, String password) async {
    await fbAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> createUser(String email, String password) async {
    try {
      final userCredentials = await fbAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final snapshot = await fb.collection('clubs').get();
      final clubs = snapshot.docs;
      List<String> availableClubs = [];
      for (var club in clubs) {
        availableClubs.add(club.id);
      }

      await fb.collection('users').doc(userCredentials.user!.uid).set({
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
  static Future<List<Club>> loadAvailableClubs(String userID) async {
    List<Club> clubs = [];
    final userData = await fb.collection('users').doc(userID).get();
    final List usersAvailableClubs = userData.data()!['available_clubs'];

    final allClubs = await fb.collection('clubs').get();
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
          ),
        );
      }
    }

    return clubs;
  }

  // return a list of joined Clubs
  static Future<List<Club>> loadJoinedClubs(String userID) async {
    List<Club> clubs = [];

    final userData = await fb.collection('users').doc(userID).get();
    final List usersJoinedClubs = userData.data()!['joined_clubs'];

    final allClubs = await fb.collection('clubs').get();
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
          ),
        );
      }
    }

    return clubs;
  }

  // Remove name from user/joined_clubs
  static void removeClub(String clubName, String userID) async {
    final userData = await fb.collection('users').doc(userID).get();

    List joinedClubs = userData.data()!['joined_clubs'];
    joinedClubs.removeWhere((name) => name == clubName);

    List availableClubs = userData.data()!['available_clubs'];
    availableClubs.add(clubName);

    await fb.collection('users').doc(userID).set({
      "joined_clubs": joinedClubs,
      "available_clubs": availableClubs,
    }, SetOptions(merge: true));
  }

  // Add name to user/joined_clubs
  static void addClub(String clubName, String userID) async {
    final userData = await fb.collection('users').doc(userID).get();

    List joinedClubs = userData.data()!['joined_clubs'];
    joinedClubs.add(clubName);

    List availableClubs = userData.data()!['available_clubs'];
    availableClubs.removeWhere((name) => name == clubName);

    await fb.collection('users').doc(userID).set({
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

    await fb.collection('users').doc(userID).set({
      "available_clubs": availableClubsNames,
      "joined_clubs": joinedClubsNames,
    }, SetOptions(merge: true));
  }

  static Future<String> getMeetingTimeFor(String clubName) async {
    final clubData = await fb.collection('clubs').doc(clubName).get();
    return clubData.data()!['meeting_time'];
  }

  static Future<String> getRecommendedTime(String clubName) async {
    final clubData = await fb.collection('clubs').doc(clubName).get();
    return clubData.data()!['recommended_time'];
  }

  static void addUserAsAdmin(Club club) async {
    final clubData = await fb.collection('clubs').doc(club.name).get();
    List admins = clubData.data()!['admins'];
    admins.add(fbAuth.currentUser!.uid);

    await fb.collection('clubs').doc(club.name).update({
      'admins': admins,
    });
  }

  static Future<bool> isAdmin(Club club) async {
    final clubData = await fb.collection('clubs').doc(club.name).get();
    final List admins = clubData.data()!['admins'];
    return admins.contains(fbAuth.currentUser!.uid);
  }
}
