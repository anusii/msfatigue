import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';

import 'package:msfatigue/constants/app.dart';
import 'package:msfatigue/main.dart' as app;
import 'package:msfatigue/utils/markdown_survey_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('App Survey Screen Test', () {
    // Test to ensure the app performs survey submit operation.
    testWidgets('Test survey page', (tester) async {
      // Build our app and trigger a frame.

      app.main();

      await tester.pumpAndSettle();

      final Finder continueButton = find.text('Continue');
      expect(continueButton, findsOneWidget);

      // Simulate tapping the Continue button.

      await tester.tap(continueButton);

      // Rebuild and allow animations to complete.

      await tester.pumpAndSettle();

      final surveyQuestions = (await markDownSurveyData(surveyFilePath)).first;

      final surveyAnswers = (await markDownSurveyData(surveyFilePath)).last;

      // Locate the first question by its text.
      final firstQuestionText = find.text(surveyQuestions.first);
      expect(firstQuestionText, findsOneWidget);

      // Locate the answer options for the first question by its text.
      final firstAnswerOption = find.text(surveyAnswers.first);
      expect(firstAnswerOption, findsNWidgets(surveyQuestions.length));

      // Tap the first answer option.
      await tester.tap(firstAnswerOption.first);

      // Find the submit button by searching for the text or widget type.
      final submitButton = find.text('Submit');
      expect(submitButton, findsOneWidget);

      // Tap the submit button.
      await tester.tap(submitButton);

      // Allow the UI to rebuild after submitting.
      await tester.pumpAndSettle();

      expect(
          find.text('Please first login in to upload survey!'), findsOneWidget);
    });
  });
}
