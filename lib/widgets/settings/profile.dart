import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
              final SnackBar snackBar;
              if (textController.text == '1234') {
                snackBar = const SnackBar(content: Text('Access Granted.'));
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
