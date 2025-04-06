import 'package:campus_clubs/providers/selected_club_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// can be consumerstate instead of stateful
class Announcements extends ConsumerWidget {
  const Announcements({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final club = ref.watch(selectedClubProvider);
    final asyncAnnouncements = ref.watch(announcementsProvider(club.name));

    return Padding(
      padding: const EdgeInsets.all(20),
      child: asyncAnnouncements.when(
        data: (announcements) => ListView.builder(
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final announcement = announcements[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: AspectRatio(
                aspectRatio: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        announcement.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        announcement.author,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
