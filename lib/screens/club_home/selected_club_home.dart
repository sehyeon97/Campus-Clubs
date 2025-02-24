import 'package:campus_clubs/models/club.dart';
import 'package:campus_clubs/providers/firestore.dart';
import 'package:campus_clubs/providers/selected_club_provider.dart';
import 'package:campus_clubs/providers/user_role_provider.dart';
import 'package:campus_clubs/screens/club_home/tabs/home.dart';
import 'package:campus_clubs/screens/club_home/tabs/leaderboard.dart';
import 'package:campus_clubs/screens/club_home/tabs/meeting_time.dart';
import 'package:campus_clubs/screens/home/home.dart';
import 'package:campus_clubs/screens/club_home/tabs/announcements.dart';
import 'package:campus_clubs/screens/club_home/tabs/events.dart';
import 'package:campus_clubs/screens/club_home/tabs/group_chat.dart';
import 'package:campus_clubs/widgets/settings/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubHome extends ConsumerStatefulWidget {
  const ClubHome({
    super.key,
  });

  @override
  ConsumerState<ClubHome> createState() => _ClubHomeState();
}

class _ClubHomeState extends ConsumerState<ClubHome> {
  int _selectedIndex = 0;

  void onDrawerItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _assignUserRole();
  }

  // is the user an admin or member of said club
  void _assignUserRole() async {
    final Club club = ref.watch(selectedClubProvider);
    if (await Firestore.isAdmin(club)) {
      ref.read(userRoleProvider.notifier).set(club.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Home(onDrawerItemTap: onDrawerItemTap),
      const Announcements(),
      const Events(),
      const Leaderboard(),
      const GroupChat(),
      const MeetingTime(),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        title: Text(ref.watch(selectedClubProvider).name),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const HomeScreen();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.home)),
          const SizedBox(width: 10.0),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const Settings();
                  });
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                onDrawerItemTap(0);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Announcements'),
              onTap: () {
                onDrawerItemTap(1);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Events'),
              onTap: () {
                onDrawerItemTap(2);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Rankings'),
              onTap: () {
                onDrawerItemTap(3);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Chat'),
              onTap: () {
                onDrawerItemTap(4);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Meeting Time'),
              onTap: () {
                onDrawerItemTap(5);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: tabs[_selectedIndex],
    );
  }
}
