import 'package:flutter/material.dart';

import 'package:msfatigue/constants/app.dart';
import 'package:msfatigue/constants/layout.dart';
import 'package:msfatigue/utils/create_survey.dart';
import 'package:msfatigue/utils/markdown_survey_data.dart';
import 'package:msfatigue/utils/pod.dart';
import 'package:msfatigue/widgets/button/submit_button.dart';
import 'package:msfatigue/widgets/dialog/show_warning.dart';
import 'package:msfatigue/widgets/question/radio_question.dart';

class SurveyPanel extends StatefulWidget {
  final String? webId;
  const SurveyPanel({required this.webId, super.key});

  @override
  State<SurveyPanel> createState() => _SurveyPanelState();
}

class _SurveyPanelState extends State<SurveyPanel> {
  List<String> questions = [];
  List<String> surveyAnswers = [];
  List<int?> qChosenList = [];

  // Update the list of selected options for the survey, with [index] specifying
  // the question being answered and [value] the selected option for the
  // question.

  void onChanged(int index, int? value) {
    setState(() {
      qChosenList[index] = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeSurveyData();
  }

  // Load the survey data using the utils function.
  Future<void> _initializeSurveyData() async {
    final loadedQuestions = (await markDownSurveyData(surveyFilePath)).first;
    final loadedAnswers = (await markDownSurveyData(surveyFilePath)).last;

    setState(() {
      questions = loadedQuestions;
      surveyAnswers = loadedAnswers;
      qChosenList = List.filled(questions.length,
          null); // Initialize qChosenList based on questions length.
    });
  }

  // Create a mapping of questions to answers using records.
  List<({String key, dynamic value})> _buildDataRecords() {
    List<({String key, dynamic value})> dataRecords = [];

    for (int i = 0; i < questions.length; i++) {
      if (qChosenList[i] != null) {
        dataRecords
            .add((key: questions[i], value: surveyAnswers[qChosenList[i]!]));
      }
    }

    return dataRecords;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double bodyWidth =
        screenWidth > 800 ? screenWidth * 0.5 : screenWidth * 0.8;
    return Center(
      child: SizedBox(
        width: bodyWidth,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    questions.length,
                    (index) => Column(
                      children: [
                        RadioQuestion(
                          questions[index],
                          surveyAnswers,
                          qChosenList[index],
                          (val) => onChanged(index, val),
                        ),
                        verticalMediumSpace(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SubmitButton(
              buttonStr: 'Submit',
              webId: widget.webId,
              onPressed: () async {
                // Check if all items in qChosenList are null.
                if (qChosenList.every((element) => element == null)) {
                  showWarning('Incomplete Submission',
                      'Please answer at least one question.', context);
                } else {
                  // Build the data map of questions and selected answers.
                  List<({String key, dynamic value})> dataRecords =
                      _buildDataRecords();
                  String fileName = createSurveyFilename();

                  await saveToPod(dataRecords, fileName, context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
