import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/features/bloc/survey_bloc.dart';
import 'package:msfatigue/questionnaire/suvey_completed.dart';
import 'package:msfatigue/utils/create_survey.dart';
import 'package:msfatigue/utils/pod.dart';
import 'package:msfatigue/widgets/drawer/side_drawer.dart';
import 'package:msfatigue/widgets/gradient_icon.dart';
import 'package:msfatigue/widgets/image/image.dart';

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Show a dialog to confirm if the user really wants to end now.
  Future<void> _showEndDialog() async {
    showDialog(
      context: context,
      builder: (dialogContext) {
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

  /// Called when the user taps the "Submit" button.

  Future<void> _handleSubmit() async {
    // Get the current SurveyState
    final surveyState = context.read<SurveyBloc>().state;

    // Retrieve preferences to check for webId
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final webId = prefs.getString('webId') ?? '';

    if (webId.isNotEmpty) {
      // Convert the responses Map to a list of records
      final dataRecords = surveyState.responses.entries
          .map((entry) => (key: entry.key, value: entry.value))
          .toList();

      // Generate a filename
      final fileName = createSurveyFilename();

      // Save data to POD
      if (!mounted) return;
      await saveToPod(dataRecords, fileName, context, isSubmit: true);
    }

    // After saving, navigate to SurveyCompleted
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveyCompleted(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        title: iconImage,
        iconTheme: const IconThemeData(size: 40, color: Colors.grey),
        leading: Builder(
          builder: (context) {
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
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),

        // "End now" button at top-right.

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

      drawer: SideDrawer(scaffoldKey: _scaffoldKey),

      // The rest of the content can be scrolled.

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/bottom_dot_four.png',
                height: 260,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: MarkdownBody(
                  selectable: true,
                  data: "Are you ready to submit?",
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/bottom_dot_five.png',
                height: 260,
              ),
            ),
            // You can put more text or instructions here
            const SizedBox(height: 80),
          ],
        ),
      ),

      // Pin "Previous" and "Submit" buttons at bottom with margin 10.

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                // e.g. go back to previous question
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_left,
                color: Colors.grey.shade700,
                size: 25,
              ),
              label: Text(
                "Previous",
                style: TextStyle(color: Colors.grey.shade700),
              ),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                side: BorderSide(color: Colors.grey.shade700, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: _handleSubmit,
              icon: const Text(
                " Submit",
                style: TextStyle(color: Colors.pink),
              ),
              label:
                  const Icon(Icons.arrow_right, color: Colors.pink, size: 25),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 2, color: Colors.pink),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
