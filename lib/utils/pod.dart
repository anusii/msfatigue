// Save data to PODs.
import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart';

import 'package:msfatigue/questionnaire/question.dart';
import 'package:msfatigue/utils/rdf.dart';
import 'package:msfatigue/widgets/dialog/show_warning.dart';

Future<bool> saveToPod(List<({String key, dynamic value})> dataRecords,
    String fileName, BuildContext context,
    {bool isSubmit = false}) async {
  if (dataRecords.isEmpty) {
    return false;
  }

  try {
    // Generate TTL str with dataMap.

    final ttlStr = await genTTLStr(dataRecords);

    // Write to POD.

    if (context.mounted) {
      await writePod(fileName, ttlStr, context, const QuestionPage());
    }

    // Show a SnackBar indicating successful upload.

    if (context.mounted) {
      if (isSubmit) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.pink,
            content: Text('Successfully saved "$fileName" to PODs'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
    return true;
  } on Exception catch (e) {
    // ignore: use_build_context_synchronously
    showWarning('Failed', 'Questions are not saved to pods', context);
    debugPrint('Exception: $e');
  }
  return false;
}
