import 'package:campus_clubs/algorithms/sort_club.dart';
import 'package:campus_clubs/models/club.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// faster time loading available clubs on user's screen
class UsersAvailableClubsProvider extends StateNotifier<List<Club>> {
  UsersAvailableClubsProvider() : super([]);

  void set(List<Club> clubs) {
    state = clubs;
  }

  void add(Club club) {
    ClubSort sortedTemp = ClubSort(clubs: state, clubToAdd: club);
    state = sortedTemp.getSortedClubs();
  }

  void remove(Club club) {
    List<Club> temp = state;
    temp.remove(club);
    state = temp;
  }
}

final userAvailableProvider =
    StateNotifierProvider<UsersAvailableClubsProvider, List<Club>>((ref) {
  return UsersAvailableClubsProvider();
});
