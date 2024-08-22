import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:msfatigue/features/review/panel.dart';
import 'package:msfatigue/features/survey/panel.dart';
import 'package:msfatigue/main.dart';
import 'package:msfatigue/home.dart';

void main() {
  group('Login Page Integration Test', () {
    // Test to ensure the login page renders correctly.

    testWidgets('Login page displays correctly', (tester) async {
      // Load the app.

      await tester.pumpWidget(const MSFatigue());

      // Allow the widget to be built and settled.

      await tester.pumpAndSettle();

      // Check that the title and images are rendered.

      expect(find.text('Survey to Pod'), findsOneWidget);

      expect(find.byType(Image), findsNWidgets(1));

      // Check that the login button is rendered.

      final Finder loginButton =
          find.byTooltip('You need to connect to your Solid Pod\n'
              'to save your survey results.');
      expect(loginButton, findsOneWidget);

      // Rebuild and allow animations to complete.

      await tester.pumpAndSettle();

      // Leave time to see the first page.

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('Click continue button', (tester) async {
      // Load the app.

      await tester.pumpWidget(const MSFatigue());

      // Allow the widget to be built and settled.

      await tester.pumpAndSettle();

      // Now, check if the "Continue" button is visible and tap it.

      final Finder continueButton =
          find.text('Continue'); // Assumes button text is "Continue"
      expect(continueButton, findsOneWidget);

      // Simulate tapping the Continue button.

      await tester.tap(continueButton);

      // Rebuild and allow animations to complete.

      await tester.pumpAndSettle();

      // Verify that the continue button was pressed by ensuring a relevant post-continue widget appears.
      // Assuming it navigates to the `HomeScreen` after clicking Continue.

      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });
  });

  group('HomeScreen Integration Test', () {
    testWidgets('HomeScreen renders with navigation and actions',
        (tester) async {
      // Load the app.

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Allow the widget to be built and settled.

      await tester.pumpAndSettle();

      // Verify AppBar title.

      expect(find.text('Home Screen'), findsOneWidget);

      // Verify Logout and Info buttons are visible.

      expect(find.byIcon(Icons.logout_sharp), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);

      // Verify Navigation Rail with two tabs.

      expect(find.text('Survey'), findsOneWidget);
      expect(find.text('Review'), findsOneWidget);

      // Initially, the SurveyPanel should be visible.

      expect(find.byType(SurveyPanel), findsOneWidget);

      // Tap on the Review tab in the NavigationRail.

      await tester.tap(find.text('Review'));
      await tester.pumpAndSettle();

      // Ensure that the ReviewPanel is now visible.

      expect(find.byType(ReviewPanel), findsOneWidget);

      // Switch back to the Survey tab.

      await tester.tap(find.text('Survey'));
      await tester.pumpAndSettle();

      // Ensure that the SurveyPanel is now visible.

      expect(find.byType(SurveyPanel), findsOneWidget);

      // Tap on the Info button and expect the About dialog to appear.

      await tester.tap(find.byIcon(Icons.info));
      await tester.pumpAndSettle();

      expect(find.text('© 2024 Software Innovation Institute ANU'),
          findsOneWidget);

      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
