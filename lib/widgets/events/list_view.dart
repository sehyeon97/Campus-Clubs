import 'package:campus_clubs/models/event_filters/event_semester.dart';
import 'package:campus_clubs/providers/event_filter_provider.dart';
import 'package:campus_clubs/providers/selected_club_provider.dart';
import 'package:campus_clubs/providers/user_role_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<String> fallMonths = <String>[
  'September',
  'October',
  'November',
  'December',
];
const List<String> springMonths = <String>[
  'January',
  'February',
  'March',
  'April',
];

class ViewAsList extends ConsumerStatefulWidget {
  const ViewAsList({super.key});

  @override
  ConsumerState<ViewAsList> createState() => _ViewAsListState();
}

class _ViewAsListState extends ConsumerState<ViewAsList> {
  @override
  Widget build(BuildContext context) {
    Semester semester = ref.watch(eventSemesterProvider);
    String dropdownValue = semester == Semester.fall ? "September" : "January";
    final bool isAdmin =
        ref.watch(userRoleProvider) == ref.watch(selectedClubProvider).name;

    DropdownMenu showDropdownMenu() {
      if (semester == Semester.fall) {
        return DropdownMenu(
          initialSelection: fallMonths.first,
          onSelected: (value) {
            setState(() {
              dropdownValue = value!;
            });
          },
          dropdownMenuEntries:
              fallMonths.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        );
      } else {
        return DropdownMenu(
          initialSelection: springMonths.first,
          onSelected: (value) {
            setState(() {
              dropdownValue = value!;
            });
          },
          dropdownMenuEntries:
              springMonths.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        );
      }
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (isAdmin)
              TextButton(
                onPressed: () {
                  AlertDialog(
                    content: Column(
                      children: [
                        showDropdownMenu(),
                      ],
                    ),
                  );
                },
                child: const Text('Create Event'),
              ),
          ],
        ),
      ),
    );
  }
}
