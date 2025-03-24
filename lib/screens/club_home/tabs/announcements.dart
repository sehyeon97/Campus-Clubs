import 'package:campus_clubs/models/club.dart';
import 'package:campus_clubs/providers/selected_club_provider.dart';
<<<<<<< HEAD
import 'package:campus_clubs/providers/users_available_clubs.dart';
=======
import 'package:campus_clubs/providers/user_role_provider.dart';
import 'package:campus_clubs/screens/club_home/admin_announcements_screen.dart';
import 'package:campus_clubs/screens/club_home/member_announcements_screen.dart';
>>>>>>> 530919319c95cfb39abc160da53843659b023e57
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
<<<<<<< HEAD
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Announcement 1',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Lorem ipsum dolor',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Announcement 2',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Lorem ipsum dolor',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Announcement 3',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Lorem ipsum dolor',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Announcement 4',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Lorem ipsum dolor',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
=======
    final Club club = ref.watch(selectedClubProvider);
    final bool isAdmin =
        ref.watch(userRoleProvider) == club.name ? true : false;

    if (isAdmin) {
      return const AdminAnnouncementsScreen();
    }

    return const MemberAnnouncementsScreen();
>>>>>>> 530919319c95cfb39abc160da53843659b023e57
  }
}
