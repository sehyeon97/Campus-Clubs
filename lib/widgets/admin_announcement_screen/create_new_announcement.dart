import 'package:flutter/material.dart';

class CreateNewAnnouncement extends StatelessWidget {
  const CreateNewAnnouncement({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _bodyController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text("Title:"),
                TextFormField(
                  controller: _titleController,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text("Body:"),
                TextFormField(
                  controller: _bodyController,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                )
              ],
            ),
            const Center(
              child: Text("Templates"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                // spring template (default given by our server)
                IconButton(onPressed: () {}, icon: const Icon(Icons.sunny)),
                // winter template (default given by our server)
                IconButton(onPressed: () {}, icon: const Icon(Icons.snowing)),
                // shows a list of custom templates made by users
                IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
              ],
            ),
            Row(),
          ],
        ),
      ),
    );
  }
}
