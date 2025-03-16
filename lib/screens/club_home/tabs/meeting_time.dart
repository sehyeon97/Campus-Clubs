import 'package:campus_clubs/models/club.dart';
import 'package:campus_clubs/providers/selected_club_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

final String userID = FirebaseAuth.instance.currentUser!.uid;
const String channel = "platform_channel";
const double heightGap = 25;

// FA24.pdf does not work because it's not a valid pdf file
// u can view this by clicking the pdf file
// const String pdfFilePath = "FA24.pdf";
const String pdfFilePath = "spring25.pdf";

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
  static const platform = MethodChannel('java/bestTimes');

  String _time = "Unknown";

  Future<void> _getMain() async {
    String time;
    try {
      final result = await platform.invokeMethod<String>('runMain');
      time = '$result';
    } on PlatformException catch (e) {
      time = 'Platform not supported';
    } on MissingPluginException catch (e) {
      time = 'Method not found';
    }

    setState(() {
      _time = time;
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
                          _time,
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
          const OutlinedButton(
            onPressed: _extractAllText,
            child: Text("Extract Text from PDF File"),
          ),
          const SizedBox(height: heightGap),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.grey),
            ),
            child: const Text("Find Best Time"),
            onPressed: () {
              _getMain();
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _extractAllText() async {
  //Load the existing PDF document.
  PdfDocument document =
      PdfDocument(inputBytes: await _readDocumentData(pdfFilePath));

  //Create the new instance of the PdfTextExtractor.
  PdfTextExtractor extractor = PdfTextExtractor(document);

  //Extract all the text from the document.
  String text = extractor.extractText();

  //Display the text.
  _showResult(text);
}

Future<List<int>> _readDocumentData(String name) async {
  final ByteData data = await rootBundle.load('lib/data/$name');
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

void _showResult(String text) {
  List<String> texts = text.split(' ');
  for (String word in texts) {
    print(word);
  }
}
