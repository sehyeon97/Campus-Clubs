import 'package:campus_clubs/models/club.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
