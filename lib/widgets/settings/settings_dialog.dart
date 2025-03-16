import 'package:campus_clubs/notification_service.dart';
import 'package:campus_clubs/widgets/settings/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerWidget {
  const Settings({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const Profile();
              }));
            },
            icon: const Icon(Icons.person),
          ),
          const Text("Profile"),
          const SizedBox(height: 20),
          IconButton(
            onPressed: () {
              NotificationService().showNotification(
                title: 'Test title',
                body: 'Test body',
              );
            },
            icon: const Icon(Icons.notifications),
          ),
          const Text("Notifications"),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
