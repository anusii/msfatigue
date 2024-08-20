import 'package:flutter/services.dart';

// Utility function to load and parse the survey data from a markdown file.
Future<List<List<String>>> markDownSurveyData(String filePath) async {
  final contents = await rootBundle.loadString(filePath);

  return [
    extractContent(
        contents, RegExp(r"## Questions\n(.*?)(\n##|$)", dotAll: true)),
    extractContent(
        contents, RegExp(r"## Answer Options\n(.*?)(\n##|$)", dotAll: true))
  ];
}

// Utility function to extract content from the markdown file.
List<String> extractContent(String markdown, RegExp regExp) {
  final questions = <String>[];
  final questionSection = regExp;
  final matches = questionSection.firstMatch(markdown);

  if (matches != null) {
    final questionBlock = matches.group(1)?.trim() ?? '';
    final questionLines = questionBlock.split('\n');
    for (var line in questionLines) {
      if (line.startsWith(RegExp(r'^\d+\.\s'))) {
        questions.add(line.trim());
      }
    }
  }

  return questions;
}
