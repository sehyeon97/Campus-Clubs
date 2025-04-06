import 'package:campus_clubs/models/club.dart';
import 'package:campus_clubs/models/announcement.dart';
import 'package:campus_clubs/providers/selected_club_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final String userID = FirebaseAuth.instance.currentUser!.uid;

class Home extends ConsumerStatefulWidget {
  const Home({super.key, required this.onDrawerItemTap,});

  final void Function(int index) onDrawerItemTap;

  @override
  ConsumerState<Home> createState() {
    return _HomeState();
  }
}

class _HomeState extends ConsumerState<Home> {

  @override
  Widget build(BuildContext context) {
    final Club club = ref.watch(selectedClubProvider);
    final asyncAnnouncements = ref.watch(announcementsProvider(club.name));

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: TextButton(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Meeting Time:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      club.meetingTime.isEmpty ? 'Unknown' : club.meetingTime,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                widget.onDrawerItemTap(5);
              },
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.topCenter,
            child: asyncAnnouncements.when(
              data: (announcements) {
                final latest = announcements.isNotEmpty ? announcements.first : null;
                return TextButton(
                  onPressed: () {
                    widget.onDrawerItemTap(1);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          latest?.title ?? 'No announcements',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          latest?.author ?? '',
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text("Error: $e"),
            ),
          ),
        ]
      )
    );
  }
}
