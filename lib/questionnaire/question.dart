import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:msfatigue/features/bloc/survey_bloc.dart';
import 'package:msfatigue/questionnaire/submit_confirmation.dart';
import 'package:msfatigue/utils/pod.dart';
import 'package:msfatigue/widgets/image/image.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<String> questions = [];
  String? webId;
  final List<String> options = [
    "Strongly disagree",
    "Disagree",
    "Agree",
    "Strongly agree",
    "Don't know",
    "Not applicable",
  ];

  final List<Color> gradientColors = [
    const Color(0xFFFFE6EB),
    const Color(0xFFFFD6DE),
    const Color(0xFFFFC6D1),
    const Color(0xFFFFB6C5),
    const Color.fromARGB(255, 200, 195, 195),
    const Color.fromARGB(255, 220, 215, 215),
  ];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _loadWebId();
  }

  /// Loads the webId from SharedPreferences via the SurveyBloc's instance.
  Future<void> _loadWebId() async {
    final prefs = context.read<SurveyBloc>().sharedPreferences;
    setState(() {
      webId = prefs.getString('webId');
    });
  }

  /// Reads the markdown file containing the questions from assets.
  Future<void> _loadQuestions() async {
    final data = await rootBundle
        .loadString('assets/markdown/fatigue_small_questionnaire.md');
    if (!mounted) return;

    setState(() {
      questions = _parseQuestions(data);
    });

    if (!mounted) return;
    // Tell the bloc to initialize the responses map with these questions.

    context.read<SurveyBloc>().add(InitializeSurvey(questions: questions));
  }

  /// Extracts lines from the markdown between "## Questions" and "## Answer Options".

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
        // Typically each question is "1. Something" => we substring after the dot+space.

        extractedQuestions.add(line.substring(line.indexOf('.') + 2).trim());
      }
    }
    return extractedQuestions;
  }

  /// Show a dialog to confirm ending the survey early.

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
                // Close button.

                Padding(
                  padding: const EdgeInsets.only(top: 0.0, right: 8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.black, size: 30),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ),
                ),
                const Text(
                  "Are you sure you want to end now? You can return to the survey any time before midnight.",
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
                    onPressed: () => Navigator.pop(dialogContext),
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

  /// Submits the survey by navigating to the SubmitConfirmation page.

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
                final int currentQuestionIndex = state.currentQuestionIndex;
                final List<String> questionKeys = state.responses.keys.toList();
                final int questionTotal = questionKeys.length;

                // Ensure we don't go out of range if there's a mismatch in question count.

                if (currentQuestionIndex >= questionKeys.length) {
                  return const Center(child: Text("No more questions."));
                }

                // The question text is the current key from the bloc's responses map.

                final String currentQuestion =
                    questionKeys[currentQuestionIndex];
                
                // The previously selected response (if any) for this question.

                final String? selectedResponse =
                    state.responses[currentQuestion];

                Future<void> handleNext() async {
                  // Dispatch NextQuestion event.

                  context.read<SurveyBloc>().add(NextQuestion());

                  // Optionally, save partial data to POD if webId is set.

                  if (webId != null && webId!.isNotEmpty) {
                    final newState = context.read<SurveyBloc>().state;
                    final String fileName = newState.surveyFilename;
                    final Map<String, String?> dataResponses =
                        newState.responses;

                    // Convert the map to your desired record format.

                    final List<({String key, dynamic value})> dataRecords = [];
                    int index = 0;
                    for (var entry in dataResponses.entries) {
                      dataRecords.add((
                        key: index.toString(),
                        value: '{${entry.key}} {${entry.value}}'
                      ));
                      index++;
                    }

                    await saveToPod(dataRecords, fileName, context);
                  }

                  // If this was the last question, navigate to submit.

                  if (currentQuestionIndex == questionTotal - 1) {
                    _submitSurvey();
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Header with iconImage & "End now" button.

                      SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: Stack(
                          children: [
                            Center(child: iconImage),
                            Positioned(
                              right: 16,
                              top: 16,
                              child: OutlinedButton(
                                onPressed: _showEndDialog,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.pink, width: 1.8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
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

                      // Progress bar (placeholder 0% fill for now).

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
                            // Example: 0% fill => replace widthFactor with a fraction if you want.

                            FractionallySizedBox(
                              widthFactor: 0.0,
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [Colors.red, Colors.pink]),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // "QUESTION x OF y".

                      Center(
                        child: Text(
                          'QUESTION ${currentQuestionIndex + 1} OF $questionTotal',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.pink),
                        ),
                      ),
                      const Gap(10),

                      // Current question text.

                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        child: Text(
                          currentQuestion,
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Gap(10),

                      // Options list.

                      Expanded(
                        child: ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            // Check if this option matches the previously selected response.

                            final bool isSelected =
                                (selectedResponse == options[index]);

                            return GestureDetector(
                              onTap: () {
                                // Dispatch UpdateResponse.

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
                            );
                          },
                        ),
                      ),

                      const Gap(25),

                      // Bottom row with "Previous", "Next", etc.

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
                              icon: Icon(Icons.arrow_left,
                                  color: (currentQuestionIndex > 0)
                                      ? Colors.grey[700]
                                      : Colors.grey),
                              label: Text(
                                "Previous    ",
                                style: TextStyle(
                                    color: (currentQuestionIndex > 0)
                                        ? Colors.grey[700]
                                        : Colors.grey),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: (currentQuestionIndex > 0)
                                      ? Colors.grey.shade700
                                      : Colors.grey,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 5),
                                alignment: Alignment.centerLeft,
                              ),
                            ),

                            // Example: Some placeholder text or a dynamic element, e.g. copyright.

                            const Text(
                              '© 2025 ANU',
                              style: TextStyle(fontSize: 12),
                            ),

                            OutlinedButton.icon(
                              onPressed: (selectedResponse != null &&
                                      selectedResponse.isNotEmpty)
                                  ? handleNext
                                  : null,
                              icon: Text(
                                "    Next",
                                style: TextStyle(
                                  color: (selectedResponse != null &&
                                          selectedResponse.isNotEmpty)
                                      ? Colors.pink
                                      : Colors.grey,
                                ),
                              ),
                              label: Icon(
                                Icons.arrow_right,
                                color: (selectedResponse != null &&
                                        selectedResponse.isNotEmpty)
                                    ? Colors.pink
                                    : Colors.grey,
                                size: 25,
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  width: 2,
                                  color: (selectedResponse != null &&
                                          selectedResponse.isNotEmpty)
                                      ? Colors.pink
                                      : Colors.grey,
                                ),
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
