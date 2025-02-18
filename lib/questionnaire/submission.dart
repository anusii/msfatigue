import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/features/bloc/survey_bloc.dart';
import 'package:msfatigue/questionnaire/suvey_completed.dart';
import 'package:msfatigue/utils/create_survey.dart';
import 'package:msfatigue/utils/pod.dart';
import 'package:msfatigue/widgets/gradient_icon.dart';
import 'package:msfatigue/widgets/image/image.dart';
import 'package:msfatigue/widgets/drawer/side_drawer.dart';

// Assume _scaffoldKey is defined globally for this widget.

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  /// Show a dialog to confirm if the user really wants to end now.
  /// Adjust the logic here if you want different end-behavior.

  Future<void> _showEndDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 5, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 2, color: Colors.pink),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Are you sure you want to end now?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "You can return to the survey any time before midnight.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurveyCompleted(),
                      ),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 46,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF79D4), Color(0xFFFF5A5F)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "Yes, end now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.pink),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Center(
                      child: Text(
                        "No, return to the survey",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        title: iconImage,
        iconTheme: const IconThemeData(
          size: 40,
          color: Colors.grey,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: GradientIcon(
                icon: Icons.menu,
                size: 40.0,
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: OutlinedButton(
              onPressed: _showEndDialog,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.pink, width: 1.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: const Text(
                'End now',
                style: TextStyle(color: Colors.pinkAccent),
              ),
            ),
          ),
        ],
      ),
      drawer: SideDrawer(scaffoldKey: scaffoldKey),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/bottom_dot_four.png',
              height: 300,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: MarkdownBody(
                  selectable: true,
                  data: "Are you ready to submit?",
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                )),
            Image.asset(
              'assets/images/bottom_dot_five.png',
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Go to previous question
                    },
                    icon: Icon(
                      Icons.arrow_left,
                      color: Colors.grey.shade700,
                      size: 25,
                    ),
                    label: Text(
                      "Previous   ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 12),
                      side: BorderSide(color: Colors.grey.shade700, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      // Retrieve the current SurveyState from the bloc before async operation.

                      final surveyState = context.read<SurveyBloc>().state;

                      // Get the SharedPreferences instance and check webId.

                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final webId = prefs.getString('webId') ?? '';
                      if (webId.isNotEmpty) {
                        // Convert the responses Map to a list of records.

                        final List<({String key, dynamic value})> dataRecords =
                            surveyState.responses.entries
                                .map((entry) =>
                                    (key: entry.key, value: entry.value))
                                .toList();

                        // Generate a filename.

                        final String fileName = createSurveyFilename();

                        // Save data to POD.

                        if (!context.mounted) return;
                        await saveToPod(dataRecords, fileName, context,
                            isSubmit: true);
                      }

                      // If successful, navigate to SurveyCompleted screen.

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurveyCompleted(),
                          ),
                        );
                      }
                    },
                    icon: const Text(
                      "    Submit",
                      style: TextStyle(color: Colors.pink),
                    ),
                    label: const Icon(
                      Icons.arrow_right,
                      color: Colors.pink,
                      size: 25,
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 2, color: Colors.pink),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 12),
                    ),
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
