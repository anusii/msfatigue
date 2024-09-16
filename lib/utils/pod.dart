// Save data to PODs.
import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart';

import 'package:msfatigue/home.dart';
import 'package:msfatigue/utils/rdf.dart';
import 'package:msfatigue/widgets/dialog/show_warning.dart';

Future<bool> saveToPod(List<({String key, dynamic value})> dataRecords,
    String fileName, BuildContext context) async {
  if (dataRecords.isEmpty) {
    return false;
  }

  try {
    // Generate TTL str with dataMap.

    final ttlStr = await genTTLStr(dataRecords);

    // Write to POD.

    if (context.mounted) {
      await writePod(fileName, ttlStr, context, const HomeScreen());
    }

    showWarning(
        'Upload',
        'Successfully saved "$fileName" to PODs',
        // ignore: use_build_context_synchronously
        context);
    return true;
  } on Exception catch (e) {
    // ignore: use_build_context_synchronously
    showWarning('Failed', 'Questions are not saved to pods', context);
    debugPrint('Exception: $e');
  }
  return false;
}
