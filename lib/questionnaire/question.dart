import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:msfatigue/constants/app.dart';
import 'package:msfatigue/features/bloc/survey_bloc.dart';
import 'package:msfatigue/questionnaire/submit_confirmation.dart';
import 'package:msfatigue/utils/markdown_survey_data.dart';
import 'package:msfatigue/utils/pod.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<String> block1Questions = [];
  List<String> block2Questions = [];
  List<String> questions = [];
  final List<String> options = [
    "Strongly disagree",
    "Disagree",
    "Agree",
    "Strongly agree",
    "Don't know",
    "Not applicable",
  ];
  final List<Color> gradientColors = [
    const Color(0xFFFFE6EB), // Very pale soft pink
    const Color(0xFFFFD6DE), // Light pale pink
    const Color(0xFFFFC6D1), // Medium pale pink
    const Color(0xFFFFB6C5), // Stronger pale pink
    const Color.fromARGB(255, 210, 205, 205),
    const Color.fromARGB(255, 210, 205, 205),
  ];

  List<String> savedQuestions = [];
  List<String> savedSurveyAnswers = [];
  List<int?> qChosenList = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _initializeSurveyData();
  }

  // Load the survey data using the utils function.

  Future<void> _initializeSurveyData() async {
    final loadedQuestions = (await markDownSurveyData(surveyFilePath)).first;
    final loadedAnswers = (await markDownSurveyData(surveyFilePath)).last;

    setState(() {
      savedQuestions = loadedQuestions;
      savedSurveyAnswers = loadedAnswers;
      qChosenList = List.filled(questions.length,
          null); // Initialize qChosenList based on questions length.
    });
  }

  Future<void> _loadQuestions() async {
    final data = await rootBundle
        .loadString('assets/markdown/fatigue_small_questionnaire.md');

    // Check if the widget is still mounted.

    if (!mounted) return;

    setState(() {
      questions = _parseQuestions(data);
      // Divide questions into Block 1 and Block 2.
      block1Questions = questions.take(6).toList();
      block2Questions = questions.skip(6).take(6).toList();
    });

    // Check again if mounted before using context for the bloc.

    if (!mounted) return;
    context.read<SurveyBloc>().add(InitializeSurvey(questions: questions));
  }

  List<String> _parseQuestions(String data) {
    final lines = data.split('\n');
    final List<String> extractedQuestions = [];
    bool isQuestion = false;

    for (var line in lines) {
      if (line.startsWith('## Questions')) {
        isQuestion = true;
      } else if (line.startsWith('## Answer Options')) {
        isQuestion = false;
      } else if (isQuestion && line.trim().isNotEmpty) {
        // Assumes each question line is prefixed with a number and a dot (e.g., "1. Question text")

        extractedQuestions.add(line.substring(line.indexOf('.') + 2).trim());
      }
    }
    return extractedQuestions;
  }

  // This helper returns the block title using local variables.

  String _getBlockTitle(int currentQuestionIndex) {
    if (currentQuestionIndex < block1Questions.length) {
      return "BLOCK 1";
    } else {
      return "BLOCK 2";
    }
  }

  Future<void> _showEndDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, right: 8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.black, size: 30),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                    ),
                  ),
                ),
                const Text(
                  "Are you sure you want to end now?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),

                const SizedBox(height: 80),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(dialogContext);
                    _submitSurvey();
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
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.pink),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Center(
                      child: Text(
                        "No, return to the survey",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
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

  void _submitSurvey() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SubmitConfirmation(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : BlocBuilder<SurveyBloc, SurveyState>(
              builder: (context, state) {
                // Get the current question by using the insertion order of the responses map.

                final int currentQuestionIndex = state.currentQuestionIndex;
                final List<String> questionsList =
                    state.responses.keys.toList();
                final String currentQuestion =
                    questionsList[currentQuestionIndex];
                final String? selectedResponse =
                    state.responses[currentQuestion];

                return Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/msFatigue_icon.png',
                                height: 75,
                              ),
                            ),
                            Positioned(
                              right: 16,
                              top: 16,
                              child: OutlinedButton(
                                onPressed: _showEndDialog,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.pink, width: 1.8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                ),
                                child: const Text(
                                  'End now',
                                  style: TextStyle(color: Colors.pinkAccent),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(5),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 8.0),
                        child: Stack(
                          children: [
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.pink[100],
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0,
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.red, Colors.pink],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          '${_getBlockTitle(currentQuestionIndex)} - QUESTION ${currentQuestionIndex + 1}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.pink),
                        ),
                      ),
                      const Gap(10),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        child: Center(
                          child: Text(
                            currentQuestion,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final bool isSelected =
                                selectedResponse == options[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  context.read<SurveyBloc>().add(
                                        UpdateResponse(
                                          questionIndex: currentQuestionIndex,
                                          response: options[index],
                                        ),
                                      );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (index >= gradientColors.length - 2
                                            ? Colors.grey[600]
                                            : Colors.pink[300])
                                        : gradientColors[index],
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 30),
                                      Text(
                                        options[index],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Gap(25),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton.icon(
                              onPressed: currentQuestionIndex > 0
                                  ? () {
                                      context
                                          .read<SurveyBloc>()
                                          .add(PreviousQuestion());
                                    }
                                  : null,
                              icon: const Icon(Icons.arrow_left,
                                  color: Colors.grey),
                              label: const Text("Previous    ",
                                  style: TextStyle(color: Colors.grey)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade400),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 5),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: (selectedResponse != null)
                                  ? () async {
                                      context
                                          .read<SurveyBloc>()
                                          .add(NextQuestion());

                                      final surveyState =
                                          BlocProvider.of<SurveyBloc>(context)
                                              .state;

                                      String fileName =
                                          surveyState.surveyFilename;

                                      Map dataResponses = surveyState.responses;

                                      List<({String key, dynamic value})>
                                          dataRecords = [];

                                      for (int i = 0;
                                          i < dataResponses.keys.length;
                                          i++) {
                                        dataRecords.add((
                                          key: i.toString(),
                                          value:
                                              '{${dataResponses.keys.toList()[i]}} {${dataResponses.values.toList()[i]}}'
                                        ));
                                      }

                                      await saveToPod(
                                          dataRecords, fileName, context);

                                      if (currentQuestionIndex ==
                                          questions.length - 1) {
                                        _submitSurvey();
                                      }
                                    }
                                  : null,
                              icon: const Text("    Next",
                                  style: TextStyle(color: Colors.pink)),
                              label: const Icon(Icons.arrow_right,
                                  color: Colors.pink),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    width: 2, color: Colors.pink),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 5),
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
