import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidpod/solidpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/features/bloc/survey_bloc.dart';
import 'package:msfatigue/questionnaire/question.dart';
import 'package:msfatigue/widgets/dialog/show_warning.dart';
import 'package:msfatigue/widgets/gradient_icon.dart';
import 'package:msfatigue/widgets/image/image.dart';
import 'package:msfatigue/widgets/drawer/side_drawer.dart';

class WelcomeBackScreen extends StatefulWidget {
  const WelcomeBackScreen({super.key});

  @override
  State<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  String latestUploadDate = '';
  String? _preferredName; // Load from SharedPreferences

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _latestUploadDate();
    _loadPreferredName();
  }

  /// Load the user's preferred name from SharedPreferences.

  Future<void> _loadPreferredName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _preferredName = prefs.getString('msfatigue_preferredName');
    });
  }

  /// extracted from the file with the latest date in [filesResources].

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

    if (latestDate == null) return ''; // If no files or parse errors
    // Change format to remove leading zero in hour: 'h' instead of 'hh'.

    return DateFormat('d MMMM yyyy h:mm a').format(latestDate.toLocal());
  }

  /// Load the latest upload date from POD.

  Future<void> _latestUploadDate() async {
    try {
      final dirUrl = await getDirUrl('msfatigue/data');
      final resources = await getResourcesInContainer(dirUrl);
      List<String> filesResources = resources.files;

      setState(() {
        latestUploadDate = getLatestDate(filesResources);
      });
    } catch (e) {
      setState(() {
        // If an error occurs, fallback to "Now".

        DateTime today = DateTime.now();
        latestUploadDate = DateFormat('d MMMM yyyy h:mm a').format(today);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final surveyState = context.read<SurveyBloc>().state;
    final dataResponses = surveyState.responses;

    final bool hasPartialData =
        dataResponses.values.any((r) => r != null && r.isNotEmpty);

    // Build a custom greeting, e.g. "Welcome back, Graham!" if _preferredName is set.

    final userNameString = (_preferredName == null || _preferredName!.isEmpty)
        ? ""
        : ", ${_preferredName!}";
    final greetingText = "Welcome back$userNameString!";

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,

      // Remove the default back arrow -> add a grey hamburger icon
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,

        // Provide a custom leading icon
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: GradientIcon(
                icon: Icons.menu,
                size: 40.0,
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey.shade50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),

        automaticallyImplyLeading: false, // don't show default back arrow
        title: iconImage,
        iconTheme: const IconThemeData(
          size: 40,
          color: Colors.grey,
        ),
      ),

      // If you'd like a drawer, reference your side drawer here.
      drawer: SideDrawer(scaffoldKey: _scaffoldKey),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10),

                  // "Welcome back, Graham!" aligned to the left.

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft, // Force left alignment
                      child: Text(
                        greetingText,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Pink container with last completed date.

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
                      hasPartialData
                          ? 'Survey not submitted yet and can be resumed'
                          : latestUploadDate.isNotEmpty
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

                  // "Continue" button.

                  SizedBox(
                    width: 320,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement navigation to survey.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionPage(
                              savedResponses: dataResponses,
                            ),
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
                        width: 330,
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
                          context,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        side: const BorderSide(color: Colors.pink),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "I'm too tired to do the survey today",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Bottom image
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
