import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/features/bloc/survey_bloc.dart';
import 'package:msfatigue/questionnaire/question.dart';
import 'package:msfatigue/widgets/page/dummy_sheet.dart';
import 'package:msfatigue/widgets/image/image.dart';
import 'package:msfatigue/welcome.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  String? preferredName;

  @override
  void initState() {
    super.initState();
    _loadPreferredName();
  }

  /// Loads the user's preferredName from SharedPreferences.

  Future<void> _loadPreferredName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      preferredName = prefs.getString('msfatigue_preferredName');
    });
  }

  /// Records the consent date/time in SharedPreferences.

  Future<void> _recordConsentDate() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dateString = DateFormat('d MMMM yyyy, h:mm a').format(now);
    await prefs.setString('consentDate', dateString);
  }

  @override
  Widget build(BuildContext context) {
    // Format "Welcome <Name>!" if we have a preferredName.

    final welcomeText = (preferredName == null || preferredName!.isEmpty)
        ? "Welcome!"
        : "Welcome ${formatPreferredName(preferredName!)}!";

    final surveyState = context.read<SurveyBloc>().state;
    final dataResponses = surveyState.responses;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 80,
        title: iconImage,
        iconTheme: const IconThemeData(size: 40, color: Colors.grey),

        // Remove the top-left back arrow.

        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              welcomeText,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 16),

            // Participant Information Sheet link.

            MarkdownBody(
              data:
                  'Please review the [Participant Information Sheet](info) for this research study on MS Fatigue.',
              onTapLink: (text, href, title) {
                if (href == 'info') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DummySheet(),
                    ),
                  );
                }
              },
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16, color: Colors.black),
                a: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            MarkdownBody(
              selectable: true,
              data:
                  "The ethical aspects of this research have been approved by the ANU Human Research Ethics Committee (2024/0698).",
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            MarkdownBody(
              selectable: true,
              data:
                  '**Please confirm** *that you have read the Participant Information Sheet provided in the above link and that you hereby give your consent to participate in this study.*',
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),

            // Row of two big buttons.

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to the WELCOME page.

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey, width: 2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "◄   No I Don't Consent",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),

                // Right: "Yes I Consent".

                ElevatedButton(
                  onPressed: () async {
                    // Record the consent date in SharedPreferences.

                    await _recordConsentDate();

                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionPage(
                          savedResponses: dataResponses,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.pink, width: 2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: MarkdownTooltip(
                    message: '''

                    By consenting you agree to share your survey answers with
                    the researchers at ANU who are conducting this research into
                    fatigure experienced by those affected by multiple
                    sclerosis. You can withdraw your consent at any time through
                    the **Withdraw** button in the side menu.

                    ''',
                    child: const Text(
                      "Yes I Consent   ►",
                      style: TextStyle(fontSize: 16, color: Colors.pink),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Bottom image
            Image.asset(
              'assets/images/bottom_dot_two.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
