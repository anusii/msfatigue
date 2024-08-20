import 'package:flutter/material.dart';

import 'package:msfatigue/constants/layout.dart';
import 'package:msfatigue/utils/solid_survey_data.dart';
import 'package:msfatigue/widgets/title/title.dart';

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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pageTitle('Files'),
                verticalMediumSpace(),
                if (files.isEmpty)
                  const Text('No files available.')
                else
                  ...files.map((file) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.insert_drive_file),
                          const SizedBox(width: 8),
                          Text(
                            file,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          );
        } else {
          // Handle the case where no data is available.
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
