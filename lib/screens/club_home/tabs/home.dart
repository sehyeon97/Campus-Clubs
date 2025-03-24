import 'package:campus_clubs/models/club.dart';
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
            child: TextButton(
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
                      'Latest Announcement:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'Lorem ipsum',
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                widget.onDrawerItemTap(1);
              },
            ),
          ),
        ]
      )
    );
  }
}
