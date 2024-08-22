import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';

import 'package:msfatigue/features/review/panel.dart';
import 'package:msfatigue/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Review Panel Integration Test', () {
    testWidgets('Displays files in review tab',
        (WidgetTester tester) async {
      // Start the app.
      app.main();

      // Wait for the app to settle (render frames, load data, etc.).
      await tester.pumpAndSettle();

      final Finder continueButton = find.text('Continue');
      expect(continueButton, findsOneWidget);

      // Simulate tapping the Continue button.

      await tester.tap(continueButton);

      // Rebuild and allow animations to complete.

      await tester.pumpAndSettle();

      // Navigate to the Review tab (assuming the review panel is in a tab).
      final reviewTab =
          find.text('Review');
      expect(reviewTab, findsOneWidget);

      // Tap the review tab.
      await tester.tap(reviewTab);

      // Wait for the data to be loaded and settle the UI.
      await tester.pumpAndSettle();

      expect(find.byType(ReviewPanel), findsOneWidget);

      // Verify that the 'No files available.' message is displayed.
      expect(find.text('No files available.'), findsOneWidget);
    });
  });
}
