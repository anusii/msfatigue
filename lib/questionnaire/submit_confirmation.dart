import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/features/bloc/survey_bloc.dart';
import 'package:msfatigue/questionnaire/welcome_back.dart';
import 'package:msfatigue/utils/create_survey.dart';
import 'package:msfatigue/utils/pod.dart';
import 'package:msfatigue/widgets/gradient_icon.dart';
import 'package:msfatigue/widgets/image/image.dart';
import 'package:msfatigue/widgets/drawer/side_drawer.dart';

// Assume _scaffoldKey is defined globally for this widget.

class SubmitConfirmation extends StatelessWidget {
  const SubmitConfirmation({super.key});

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
      ),
      drawer: SideDrawer(scaffoldKey: scaffoldKey),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/bottom_dot_four.png',
              height: 220,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: MarkdownBody(
                  selectable: true,
                  data: "Thank you for your participation.\n\n"
                      "Any questions you have already answered will be saved until Midnight. You can come back before then to complete the survey. To continue now, tap **Resume**. Otherwise tap **Finish**.",
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 18),
                  ),
                )),
            Image.asset(
              'assets/images/bottom_dot_five.png',
              height: 220,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
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
                      "Resume   ",
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
                            builder: (context) => WelcomeBackScreen(),
                          ),
                        );
                      }
                    },
                    icon: const Text(
                      "    Finish",
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
