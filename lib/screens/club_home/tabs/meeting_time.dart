import 'package:campus_clubs/providers/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final String userID = FirebaseAuth.instance.currentUser!.uid;
const String channel = "platform_channel";

class MeetingTime extends StatefulWidget {
  const MeetingTime({
    super.key,
    required this.clubName,
  });
  final String clubName;

  @override
  State<StatefulWidget> createState() {
    return _MeetingTimeState();
  }
}

// implement two things:
// 1) a time range showing the recommended time frame given the submitted schedules
// 2) the decided meeting time by the president (zero if not decided)
// 3) a button for user to submit the pdf version of their schedule
// 4) a popup for any errors encountered with appropriate dialogs
// 5) a button that reveals a form for users to enter a preferred meeting time manually
class _MeetingTimeState extends State<MeetingTime> {
  late final String meetingTime;
  late final String recommendedTime;

  @override
  void initState() {
    super.initState();
    setTimeVariables();
  }

  void setTimeVariables() async {
    meetingTime = await Firestore.getMeetingTimeFor(widget.clubName);
    recommendedTime = await Firestore.getRecommendedTime(widget.clubName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Meeting Time for ${widget.clubName}'),
        const SizedBox(height: 20),
        Text(meetingTime),
        const SizedBox(height: 20),
        const Text("Recommended Time"),
        const SizedBox(height: 20),
        Text(recommendedTime),
        const SizedBox(height: 20),
        const Text(
          "Submit your current schedule for the semester to change Recommended Time",
        ),
        OutlinedButton(
          child: const Text("Submit School Schedule"),
          onPressed: () {
            // TODO: This should talk with the Platform Channels
          },
        ),
      ],
    );
  }
}
