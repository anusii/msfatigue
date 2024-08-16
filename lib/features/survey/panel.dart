import 'package:flutter/material.dart';

import 'package:msfatigue/constants/layout.dart';
import 'package:msfatigue/constants/survey.dart';
import 'package:msfatigue/widgets/button/submit_button.dart';
import 'package:msfatigue/widgets/question/radio_question.dart';

class SurveyPanel extends StatefulWidget {
  const SurveyPanel({super.key});

  @override
  State<SurveyPanel> createState() => _SurveyPanelState();
}

class _SurveyPanelState extends State<SurveyPanel> {
  // The list of selected options for the survey. The initial value for each
  // question is null.

  List<int?> qChosenList = List.filled(questions.length, null);

  // Update the list of selected options for the survey, with [index] specifying
  // the question being answered and [value] the selected option for the
  // question.

  void onChanged(int index, int? value) {
    setState(() {
      qChosenList[index] = value;
    });
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
                          subSurveyAnswers,
                          qChosenList[index],
                          (val) => onChanged(index, val),
                        ),
                        verticalMediumSpace(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SubmitButton(
              buttonStr: 'Submit',
              onPressed: () {
                print('');
              },
            ),
          ],
        ),
      ),
    );
  }
}
