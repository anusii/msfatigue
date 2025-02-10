import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:msfatigue/features/bloc/survey_bloc.dart';
import 'package:msfatigue/questionnaire/suvey_completed.dart';
import 'package:msfatigue/utils/create_survey.dart';
import 'package:msfatigue/utils/pod.dart';
import 'package:msfatigue/widgets/drawer/side_drawer.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class SubmitConfirmation extends StatelessWidget {
  const SubmitConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/msFatigue_icon.png',
                height: 65,
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          size: 50,
        ),
      ),
      drawer: SideDrawer(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/bottom_dot_four.png',
              height: 260,
            ),
            const Text(
              "Are you ready to submit?",
              style: TextStyle(
                fontSize: 28,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Image.asset(
              'assets/images/bottom_dot_five.png',
              height: 260,
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
                      // Retrieve the current SurveyState from the bloc.

                      final surveyState = context.read<SurveyBloc>().state;

                      // Convert the responses Map to a list of records.

                      final List<({String key, dynamic value})> dataRecords =
                          surveyState.responses.entries
                              .map((entry) =>
                                  (key: entry.key, value: entry.value))
                              .toList();

                      String fileName = createSurveyFilename();

                      await saveToPod(dataRecords, fileName, context,
                          isSubmit: true);

                      // Now pass the dataRecords to the SurveyCompleted screen.

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
                      side: const BorderSide(
                        width: 2,
                        color: Colors.pink,
                      ),
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
