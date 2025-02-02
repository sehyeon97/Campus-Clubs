import 'package:campus_clubs/models/event_filters/event_semester.dart';
import 'package:campus_clubs/providers/event_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends ConsumerWidget {
  const CalendarView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime today = DateTime.now();
    final semester = ref.watch(eventSemesterProvider);

    if (semester == Semester.fall) {
      return TableCalendar(
        headerVisible: true,
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        focusedDay: DateTime(today.year - 1, 9, 5),
        firstDay: DateTime(
          today.year - 1,
          9,
          1,
        ),
        lastDay: DateTime(
          today.year - 1,
          12,
          31,
        ),
        calendarFormat: CalendarFormat.month,
        onDaySelected: (selectedDay, focusedDay) {},
      );
    }

    return TableCalendar(
      headerVisible: true,
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
      focusedDay: DateTime(today.year, 1, 1),
      firstDay: DateTime(
        today.year,
        1,
        1,
      ),
      lastDay: DateTime(
        today.year,
        4,
        30,
      ),
      calendarFormat: CalendarFormat.month,
      onDaySelected: (selectedDay, focusedDay) {},
    );
  }
}
