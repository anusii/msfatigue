import 'package:flutter/material.dart';

import 'package:path/path.dart' as path;
import 'package:solidpod/solidpod.dart';

import 'package:msfatigue/utils/clean_number_dot.dart';
import 'package:msfatigue/utils/rdf.dart';

/// Shows a dialog with the content of the selected file.
///
/// [fileName] is displayed in the dialog's title and [content] in its body.
void showFileContent(
  String fileName,
  BuildContext context,
) async {
  final dataDirPath = await getDataDirPath();
  final filePath = path.join(dataDirPath, fileName);

  try {
    String content = await readPod(filePath, context, Container());
    Map questionsList = await listSurveyQuestions(content);

    if (questionsList.isNotEmpty) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(fileName),
            content: SingleChildScrollView(
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2), // Question column width
                  1: FlexColumnWidth(1), // Answer column width
                },
                border:
                    TableBorder.all(color: Colors.grey), // Add borders to table
                children: [
                  // Header Row
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Question',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Answer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Data Rows.
                  for (var entry in questionsList.entries)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            cleanNumberDot(entry.key),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            cleanNumberDot(entry.value),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }

    // ignore: empty_catches
  } catch (e) {}
}
