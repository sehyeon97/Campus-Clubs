import 'package:campus_clubs/widgets/admin_announcement_screen/create_new_announcement.dart';
import 'package:campus_clubs/widgets/admin_announcement_screen/edit_announcement.dart';
import 'package:campus_clubs/widgets/admin_announcement_screen/remove_announcement.dart';
import 'package:campus_clubs/widgets/admin_announcement_screen/template_announcement.dart';
import 'package:campus_clubs/widgets/member_announcement_screen/member_view.dart';
import 'package:flutter/material.dart';

class AdminAnnouncementsScreen extends StatefulWidget {
  const AdminAnnouncementsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminAnnouncementsScreenState();
  }
}

class _AdminAnnouncementsScreenState extends State<AdminAnnouncementsScreen> {
  // false views admin screen, true views member screen
  bool _screenViewToggler = false;
  String _screenViewMessage = "View Member Screen";

  void _screenToggler() {
    setState(() {
      _screenViewToggler = !_screenViewToggler;
      if (_screenViewToggler) {
        _screenViewMessage = "View Admin Screen";
      } else {
        _screenViewMessage = "View Member Screen";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_screenViewToggler) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => _screenToggler(),
              child: Text(_screenViewMessage),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => const CreateNewAnnouncement(),
              child: const Text("Create New Announcement"),
            ),
            ElevatedButton(
              onPressed: () => const EditAnnouncement(),
              child: const Text("Edit Announcement"),
            ),
            ElevatedButton(
              onPressed: () => const DeleteAnnouncement(),
              child: const Text("Delete Announcement"),
            ),
            ElevatedButton(
              onPressed: () => const TemplateAnnouncement(),
              child: const Text("Create Custom Announcement Template"),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => _screenToggler(),
            child: Text(_screenViewMessage),
          ),
          const MemberView(),
        ],
      ),
    );
  }
}
