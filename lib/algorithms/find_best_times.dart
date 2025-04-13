import 'dart:io';
import 'dart:math';
import 'package:campus_clubs/models/timeslot.dart';

class FindBestTimes {
  static String runMain(List<String> fileData) {
    // List<String> fileData = getFileData(filePath);
    List<Timeslot> timeslotData = toTimeslots(fileData);
    List<List<int>> schedule = createNewSchedule();
    schedule = addTimes(schedule, timeslotData);

    // final Random r = Random();
    // for (int i = 0; i < 7; i++) {
    //   for (int j = 0; j < 73; j++) {
    //     schedule[i][j] = r.nextInt(50);
    //   }
    // }

    int c = 'M'.codeUnitAt(0);
    int index;
    switch (String.fromCharCode(c)) {
      case 'M':
        index = 1;
        break;
      case 'T':
        index = 2;
        break;
      case 'W':
        index = 3;
        break;
      case 'R':
        index = 4;
        break;
      case 'F':
        index = 5;
        break;
      default:
        index = 0;
    }

    List<Timeslot> bestTimes = getBestTimes(schedule[index], String.fromCharCode(c));
    return bestTimes.isNotEmpty ? bestTimes[0].toString() : "No best time found";
  }

  static List<String> getFileData(String filename) {
    final file = File(filename);
    List<String> fileData = [];
    try {
      List<String> lines = file.readAsLinesSync();
      for (String line in lines) {
        int i = 0;
        while (line[i] != ' ') {
          fileData.add(removeLetters(line, line[i]));
          i++;
        }
      }
    } catch (_) {
      // Error handling omitted
    }
    return fileData;
  }

  static String removeLetters(String line, String x) {
    List<String> tokens = line.split(' ');
    return '$x ${tokens[1]}';
  }

  static List<Timeslot> toTimeslots(List<String> fileData) {
    return fileData.map((s) => Timeslot.fromString(s)).toList();
  }

  static List<List<int>> createNewSchedule() {
    return List.generate(7, (_) => List.filled(73, 0));
  }

  static List<List<int>> addTimes(List<List<int>> schedule, List<Timeslot> timeslotData) {
    for (Timeslot ts in timeslotData) {
      for (int i = getIndex(ts.hours1, ts.minutes1); i <= getIndex(ts.hours2, ts.minutes2); i++) {
        int dayIndex = switch (ts.day) {
          'M' => 1,
          'T' => 2,
          'W' => 3,
          'R' => 4,
          'F' => 5,
          _ => 0,
        };
        schedule[dayIndex][i] += 1;
      }
    }
    return schedule;
  }

  static int getIndex(int hours, int minutes) {
    return (hours - 6) * 4 + (minutes ~/ 15);
  }

  static List<Timeslot> getBestTimes(List<int> a, String day) {
    List<Timeslot> bestTimeslots = [];

    if (a.length < 4) return bestTimeslots;
    if (a.length == 4) {
      bestTimeslots.add(Timeslot.fromString('$day 06:00-07:00'));
      return bestTimeslots;
    }

    int window = a[0] + a[1] + a[2] + a[3];
    int min = window;

    for (int i = 1; i < a.length - 3; i++) {
      window = window - a[i - 1] + a[i + 3];
      if (window < min) {
        min = window;
      }
    }

    window = a[0] + a[1] + a[2] + a[3];
    if (window == min) {
      bestTimeslots.add(Timeslot.fromString('$day 06:00-07:00'));
    }

    for (int i = 1; i < a.length - 3; i++) {
      window = window - a[i - 1] + a[i + 3];
      if (window == min) {
        bestTimeslots.add(Timeslot.fromString('$day ${getTime(i)}'));
      }
    }

    return bestTimeslots;
  }

  static String getTime(int index) {
    int hours = index ~/ 4 + 6;
    int minutes = switch (index % 4) {
      1 => 15,
      2 => 30,
      3 => 45,
      _ => 0,
    };

    int endHour = hours + 1;
    String format(int x) => x < 10 ? '0$x' : '$x';
    String start = '${format(hours)}:${format(minutes)}';
    String end = '${format(endHour)}:${format(minutes)}';
    return '$start-$end';
  }
}