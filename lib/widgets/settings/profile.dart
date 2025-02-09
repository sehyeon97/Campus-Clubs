import 'package:campus_clubs/providers/firestore.dart';
import 'package:campus_clubs/providers/selected_club_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          const Text('Enter Admin Access Pin to gain Admin Status'),
          TextField(
            controller: textController,
            autocorrect: false,
            obscureText: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Admin Access Pin',
            ),
          ),
          OutlinedButton(
            onPressed: () {
              // TODO: This will not be necessary when web scraping extracts president and advisor
              final SnackBar snackBar;
              if (textController.text == '1234') {
                snackBar = const SnackBar(content: Text('Access Granted.'));
                Firestore.addUserAsAdmin(ref.watch(selectedClubProvider));
              } else {
                snackBar =
                    const SnackBar(content: Text('Access cannot be granted.'));
              }
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text('Get Access'),
          ),
        ],
      ),
    );
  }
}
