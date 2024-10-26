import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<String> questions = [];
  final List<String> options = [
    "Strongly disagree",
    "Disagree",
    "Neither agree nor disagree",
    "Agree",
    "Strongly agree",
  ];
  final List<String> additionalOptions = ["Don't know", "Not applicable"];
  int _currentQuestionIndex = 0;
  String? _selectedOption;
  String? _selectedAdditionalOption;

  // Define the colors for each option button in the specified order.

  final List<Color> optionColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow[700]!, // Yellow color with higher contrast
    Colors.green,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final data =
        await rootBundle.loadString('assets/markdown/fatigue_questionnaire.md');
    setState(() {
      questions = _parseQuestions(data);
    });
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
        extractedQuestions.add(line.substring(line.indexOf('.') + 2).trim());
      }
    }

    return extractedQuestions;
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
        _selectedOption = null;
        _selectedAdditionalOption = null;
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
        _selectedOption = null;
        _selectedAdditionalOption = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MS Fatigue"),
        actions: [
          TextButton(
            onPressed: () {
              // Handle "End now" action here
            },
            child: const Text(
              "End now",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Question title
                  Center(
                    child: Text(
                      'QUESTION ${_currentQuestionIndex + 1}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Question text.

                  Text(
                    questions[_currentQuestionIndex],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Answer options as colorful buttons.

                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedOption = options[index];
                                _selectedAdditionalOption = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedOption == options[index]
                                  ? optionColors[index]
                                  : optionColors[index].withOpacity(0.5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              options[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedOption == options[index]
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Additional options as radio buttons.

                  Column(
                    children: additionalOptions.map((option) {
                      return RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: _selectedAdditionalOption,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedAdditionalOption = value;
                            _selectedOption = null;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  // Navigation buttons.
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _currentQuestionIndex > 0
                            ? _previousQuestion
                            : null,
                        child: const Text("Previous"),
                      ),
                      ElevatedButton(
                        onPressed: (_selectedOption != null ||
                                _selectedAdditionalOption != null)
                            ? _nextQuestion
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
