import 'package:flutter_riverpod/flutter_riverpod.dart';

// state is the name of club
// user can be admin of max one club
// this stores only the club the user is an admin of
class UserRoleProvider extends StateNotifier<String> {
  UserRoleProvider() : super("");

  void set(String clubName) {
    state = clubName;
  }
}

final userRoleProvider = StateNotifierProvider<UserRoleProvider, String>((ref) {
  return UserRoleProvider();
});
