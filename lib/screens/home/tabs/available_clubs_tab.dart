import 'package:campus_clubs/models/club.dart';
import 'package:campus_clubs/providers/feedback.dart';
import 'package:campus_clubs/providers/users_available_clubs.dart';
import 'package:campus_clubs/providers/users_joined_clubs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final _firebase = FirebaseFirestore.instance;
final String userID = FirebaseAuth.instance.currentUser!.uid;

class AvailableClubs extends ConsumerStatefulWidget {
  const AvailableClubs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AvailableClubsState();
  }
}

class _AvailableClubsState extends ConsumerState<AvailableClubs> {
  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Club> availableClubs = ref.watch(userAvailableProvider);

    return Center(
      child: ListView.builder(
        itemCount: availableClubs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(availableClubs[index].name),
                            Text(availableClubs[index].description),
                            Text(availableClubs[index].president),
                            Text(availableClubs[index].advisor),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    FeedbackSystem
                                        .getSuccessfullyJoinedClubFeedback(
                                            availableClubs[index].name));
                                ref
                                    .read(userJoinedClubsProvider.notifier)
                                    .add(availableClubs[index]);
                                ref
                                    .read(userAvailableProvider.notifier)
                                    .remove(availableClubs[index]);
                                Navigator.of(context).pop();
                                refreshPage();
                              },
                              child: const Text("Join now!"),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Text(availableClubs[index].name),
            ),
          );
        },
      ),
    );
  }
}
