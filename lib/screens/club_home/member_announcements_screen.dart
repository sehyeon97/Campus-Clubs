import 'package:campus_clubs/widgets/member_announcement_screen/member_view.dart';
import 'package:flutter/material.dart';

class MemberAnnouncementsScreen extends StatefulWidget {
  const MemberAnnouncementsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MemberAnnouncementsScreenState();
  }
}

class _MemberAnnouncementsScreenState extends State<MemberAnnouncementsScreen> {
  @override
  Widget build(BuildContext context) {
    return const MemberView();
  }
}
