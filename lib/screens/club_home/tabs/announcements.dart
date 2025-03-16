import 'package:campus_clubs/models/club.dart';
import 'package:campus_clubs/providers/selected_club_provider.dart';
import 'package:campus_clubs/providers/user_role_provider.dart';
import 'package:campus_clubs/screens/club_home/admin_announcements_screen.dart';
import 'package:campus_clubs/screens/club_home/member_announcements_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// can be consumerstate instead of stateful
class Announcements extends ConsumerStatefulWidget {
  const Announcements({
    super.key,
  });

  @override
  ConsumerState<Announcements> createState() {
    return _AnnouncementsState();
  }
}

class _AnnouncementsState extends ConsumerState<Announcements> {
  @override
  Widget build(BuildContext context) {
    final Club club = ref.watch(selectedClubProvider);
    final bool isAdmin =
        ref.watch(userRoleProvider) == club.name ? true : false;

    if (isAdmin) {
      return const AdminAnnouncementsScreen();
    }

    return const MemberAnnouncementsScreen();
  }
}
