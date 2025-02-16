import 'package:campus_clubs/models/club.dart';
import 'package:campus_clubs/providers/feedback.dart';
import 'package:campus_clubs/providers/selected_club_provider.dart';
import 'package:campus_clubs/providers/users_available_clubs.dart';
import 'package:campus_clubs/providers/users_joined_clubs.dart';
import 'package:campus_clubs/screens/club_home/selected_club_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final _firebase = FirebaseFirestore.instance;
final String userID = FirebaseAuth.instance.currentUser!.uid;

class UsersClubs extends ConsumerStatefulWidget {
  const UsersClubs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UsersClubsState();
  }
}

class _UsersClubsState extends ConsumerState<UsersClubs> {
  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Club> joinedClubs = ref.watch(userJoinedClubsProvider);

    if (joinedClubs.isEmpty) {
      return const Center(
        child: Text("You are not in any clubs :("),
      );
    }

    return Center(
      child: ListView.builder(
        itemCount: joinedClubs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child:
                                Text("Leave ${joinedClubs[index].name} Club?"),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      FeedbackSystem
                                          .getSuccessfullyJoinedClubFeedback(
                                              joinedClubs[index].name));
                                  ref
                                      .read(userAvailableProvider.notifier)
                                      .add(joinedClubs[index]);
                                  ref
                                      .read(userJoinedClubsProvider.notifier)
                                      .remove(joinedClubs[index]);
                                  Navigator.of(dialogContext).pop();
                                  refreshPage();
                                },
                                child: const Text("Yes"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                                child: const Text("No"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              onPressed: () {
                ref.read(selectedClubProvider.notifier).setClub(
                      Club(
                        name: joinedClubs[index].name,
                        description: joinedClubs[index].description,
                        president: joinedClubs[index].president,
                        advisor: joinedClubs[index].advisor,
                        meetingTime: joinedClubs[index].meetingTime,
                        recommendedTime: joinedClubs[index].recommendedTime,
                      ),
                    );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ClubHome();
                    },
                  ),
                );
              },
              child: Text(joinedClubs[index].name),
            ),
          );
        },
      ),
    );
  }
}
