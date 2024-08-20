import 'package:flutter/material.dart';

import 'package:msfatigue/features/review/display.dart';
import 'package:msfatigue/utils/solid_survey_data.dart';

class ReviewPanel extends StatefulWidget {
  const ReviewPanel({super.key});

  @override
  State<ReviewPanel> createState() => _ReviewPanelState();
}

class _ReviewPanelState extends State<ReviewPanel> {
  Future<({List<String> files, List<String> subDirs})>? surveyRecords;

  @override
  void initState() {
    super.initState();

    // Load the survey records after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var loadedRecords = await solidSurveyData();

      // Update the state with loaded records.
      setState(() {
        surveyRecords = Future.value(loadedRecords);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<({List<String> files, List<String> subDirs})>(
      future: surveyRecords,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display loading spinner while data is loading.
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle any errors.
          return const Center(child: Text('Error loading data'));
        } else if (snapshot.hasData) {
          var files = snapshot.data!.files;

          return ViewDisplay(
            title: 'Files',
            files: files,
          );
        } else {
          // Handle the case where no data is available.
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
