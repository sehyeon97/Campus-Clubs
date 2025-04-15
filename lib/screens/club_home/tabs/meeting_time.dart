import 'package:campus_clubs/models/club.dart';
import 'package:campus_clubs/providers/selected_club_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:campus_clubs/algorithms/find_best_times.dart';

final String userID = FirebaseAuth.instance.currentUser!.uid;
const double heightGap = 25;

// FA24.pdf does not work because it's not a valid pdf file
// u can view this by clicking the pdf file
// const String pdfFilePath = "FA24.pdf";
const String pdfFilePath = "FA24.pdf";

class MeetingTime extends ConsumerStatefulWidget {
  const MeetingTime({
    super.key,
  });

  @override
  ConsumerState<MeetingTime> createState() {
    return _MeetingTimeState();
  }
}

// implement two things:
// 1) a time range showing the recommended time frame given the submitted schedules
// 2) the decided meeting time by the president (zero if not decided)
// 3) a button for user to submit the pdf version of their schedule
// 4) a popup for any errors encountered with appropriate dialogs
// 5) a button that reveals a form for users to enter a preferred meeting time manually
class _MeetingTimeState extends ConsumerState<MeetingTime> {
  String _recTime = "Unknown";

  Future<void> extractAllText() async {
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData(pdfFilePath));
    PdfTextExtractor extractor = PdfTextExtractor(document);
    String text = extractor.extractText();
    String normalizedText = _normalizeText(text);
    String result = outputResult(normalizedText);

    setState(() {
      _recTime = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Club club = ref.watch(selectedClubProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Meeting Time',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          club.meetingTime.isEmpty
                              ? 'Unknown'
                              : club.meetingTime,
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Recommended",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _recTime,
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: heightGap * 2),
          Container(
            padding: const EdgeInsets.all(16),
            width: 300, // TODO: Change to ratio in context of screen width
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              "Submit your current schedule for the semester to update time",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: heightGap),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.grey),
            ),
            child: const Text("Find Best Time"),
            onPressed: () {
              extractAllText();
            },
          ),
        ],
      ),
    );
  }
}

String _normalizeText(String text) {
  text = text.replaceAll(RegExp(r'\u00A0'), ' ');
  text = text.replaceAll(RegExp(r'[ \t]+'), ' ');

  text = text
      .split('\n')
      .map((line) => line.trim())
      .join('\n');

  return text;
}

Future<List<int>> _readDocumentData(String name) async {
  final ByteData data = await rootBundle.load('lib/data/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

String outputResult(String text) {
  List<String> lines = text.split('\n');
  List<String> result = [];

  for (String line in lines) {
    if (line.contains("AM") || line.contains("PM")) {
      result.add(line);
    }
  }

  List<String> resultRunMain = expandSchedule(result);
  print(resultRunMain);

  return FindBestTimes.runMain(resultRunMain);
}

List<String> expandSchedule(List<String> inputList) {
  List<String> expanded = [];

  final validPattern = RegExp(r'^[MTWRF]+ \d{2}:\d{2}-\d{2}:\d{2}[AP]M$');

  for (String entry in inputList) {
    final cleaned = entry.trim();

    if (!validPattern.hasMatch(cleaned)) {
      continue;
    }

    final match = RegExp(r'^([MTWRF]+)\s+(.+)$').firstMatch(cleaned);
    if (match != null) {
      String days = match.group(1)!;
      String time = match.group(2)!;

      for (int i = 0; i < days.length; i++) {
        expanded.add('${days[i]} $time');
      }
    }
  }

  return expanded;
}