import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:solidpod/solidpod.dart';

import 'package:msfatigue/questionnaire/question.dart';
import 'package:msfatigue/widgets/dialog/show_warning.dart';

class WelcomeBackScreen extends StatefulWidget {
  const WelcomeBackScreen({super.key});

  @override
  State<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  String latestUploadDate = '';
  @override
  void initState() {
    super.initState();
    _latestUploadDate();
  }

  /// Returns the timestamp string (e.g., "20250206T134801")
  /// extracted from the file with the latest date in [fileResources].
  String getLatestDate(List<String> filesResources) {
    DateTime? latestDate;

    for (String file in filesResources) {
      try {
        String dateTimeStr = file.split('_')[1].split('.')[0];
        List<String> parts = dateTimeStr.split('T');
        if (parts.length != 2) continue;

        String datePart = parts[0];
        String timePart = parts[1];

        if (datePart.length != 8 || timePart.length != 6) continue;

        int year = int.parse(datePart.substring(0, 4));
        int month = int.parse(datePart.substring(4, 6));
        int day = int.parse(datePart.substring(6, 8));

        int hour = int.parse(timePart.substring(0, 2));
        int minute = int.parse(timePart.substring(2, 4));
        int second = int.parse(timePart.substring(4, 6));

        DateTime date = DateTime.utc(year, month, day, hour, minute, second);

        if (latestDate == null || date.isAfter(latestDate)) {
          latestDate = date;
        }
      } catch (e) {
        // Handle parsing errors if any file is malformed
        continue;
      }
    }

    if (latestDate == null) return ''; // Handle empty list case

    return DateFormat('d MMMM yyyy hh:mm a').format(latestDate);
  }

  Future<void> _latestUploadDate() async {
    try {
      // Get URL of directory containing blood pressure data.

      final dirUrl = await getDirUrl('msfatigue/data');

      // Retrieve list of files (resources) in directory.

      final resources = await getResourcesInContainer(dirUrl);

      List<String> filesResources = resources.files;

      // Convert the list of resources to a single string (each resource on a new line).

      setState(() {
        latestUploadDate = getLatestDate(filesResources);
      });
    } catch (e) {
      setState(() {
        DateTime today = DateTime.now();
        latestUploadDate = DateFormat('d MMMM yyyy hh:mm a').format(today);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Center(
          child: Image.asset(
            'assets/images/msFatigue_icon.png',
            height: 65,
          ),
        ),
        iconTheme: const IconThemeData(
          size: 50,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                    ),
                    child: Text(
                      latestUploadDate.isNotEmpty
                          ? 'Survey last completed: $latestUploadDate'
                          : 'Survey not submitted yet.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 320,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement navigation to survey.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuestionPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Container(
                        width: 320,
                        height: 46,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF85E2),
                              Color(0xFFFF5A5F),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Take me to the survey',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 320,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () {
                        showWarning(
                            'Info',
                            "That's okay. When you are ready you can come back to the survey.",
                            context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        side: const BorderSide(color: Colors.pink),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "I'm too tired to complete this survey",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/bottom_dot_three.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
