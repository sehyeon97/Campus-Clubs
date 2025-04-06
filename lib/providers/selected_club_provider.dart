import 'package:campus_clubs/models/club.dart';
import 'package:campus_clubs/models/announcement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_clubs/providers/firestore.dart';

class SelectedClubProvider extends StateNotifier<Club> {
  SelectedClubProvider()
      : super(
          const Club(
            name: 'name',
            description: 'description',
            president: 'president',
            advisor: 'advisor',
            meetingTime: 'meeting time',
            recommendedTime: 'recommended time',
            adminEmails: [],
            adminIDs: [],
          ),
        );

  void setClub(Club club) {
    state = club;
  }
}

final selectedClubProvider =
    StateNotifierProvider<SelectedClubProvider, Club>((ref) {
  return SelectedClubProvider();
});

final announcementsProvider = FutureProvider.family<List<Announcement>, String>((ref, clubName) async {
  return await Firestore.getAnnouncements(clubName);
});