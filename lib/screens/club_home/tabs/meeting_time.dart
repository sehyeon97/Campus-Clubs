import 'package:campus_clubs/models/club.dart';
import 'package:campus_clubs/providers/selected_club_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final String userID = FirebaseAuth.instance.currentUser!.uid;
const String channel = "platform_channel";
const double heightGap = 50;

class MeetingTime extends ConsumerStatefulWidget {
  const MeetingTime({
    super.key,
  });

  @override
  ConsumerState<MeetingTime> createState() {
    return _MeetingTimeState();
  }
}

// implement two things:
// 1) a time range showing the recommended time frame given the submitted schedules
// 2) the decided meeting time by the president (zero if not decided)
// 3) a button for user to submit the pdf version of their schedule
// 4) a popup for any errors encountered with appropriate dialogs
// 5) a button that reveals a form for users to enter a preferred meeting time manually
class _MeetingTimeState extends ConsumerState<MeetingTime> {
  @override
  Widget build(BuildContext context) {
    final Club club = ref.watch(selectedClubProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: heightGap),
        Text('Meeting Time for ${club.name}'),
        const SizedBox(height: heightGap),
        Text(
          club.meetingTime == ""
              ? 'Meeting Time has not yet been decided'
              : club.meetingTime,
        ),
        const SizedBox(height: heightGap),
        const Text("Recommended Time"),
        const SizedBox(height: heightGap),
        Text(
          club.recommendedTime == ""
              ? 'Insufficient information to provide suggestions'
              : club.recommendedTime,
        ),
        const SizedBox(height: heightGap),
        const Text(
          "Submit your current schedule for the semester to change Recommended Time",
        ),
        OutlinedButton(
          child: const Text("Submit School Schedule"),
          onPressed: () {
            // TODO: This should talk with the Platform Channels
          },
        ),
        const SizedBox(height: heightGap),
      ],
    );
  }
}
