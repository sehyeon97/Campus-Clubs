import 'package:campus_clubs/models/event_filters/event_semester.dart';
import 'package:campus_clubs/providers/event_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CalendarViewState();
  }
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final semester = ref.watch(eventSemesterProvider);

    void _eventPopup() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  children: [],
                ),
              ),
            );
          });
    }

    if (semester == Semester.fall) {
      return TableCalendar(
        headerVisible: true,
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        focusedDay: today,
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
      focusedDay: today,
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
