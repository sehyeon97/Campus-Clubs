import 'package:flutter/material.dart';

class EditAnnouncement extends StatefulWidget {
  const EditAnnouncement({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EditAnnouncementState();
  }
}

class _EditAnnouncementState extends State<EditAnnouncement> {
  bool _announcementSelected = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text("Last Posted"),
            ),
            const SizedBox(height: 20),
            const Text("Fetch By"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Date"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Title"),
                ),
              ],
            ),
            if (_announcementSelected)
              Column(
                children: [
                  const Text("Leave blank to not change field"),
                  Row(
                    children: [
                      const Text("New Title"),
                      TextFormField(
                        controller: _titleController,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text("New Body"),
                      TextFormField(
                        controller: _bodyController,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Select Different Template"),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Submit"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
