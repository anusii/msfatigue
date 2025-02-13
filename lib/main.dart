/// A Survey App for MS Fatigue Project.
///
// Time-stamp: <Friday 2024-08-16 12:34:33 +1000 Graham Williams>
///
/// Copyright (C) 2024, Software Innovation Institute, ANU.
///
/// Licensed under the GNU General Public License, Version 3 (the "License").
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html.
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:msfatigue/features/bloc/survey_bloc.dart';
import 'package:msfatigue/widgets/page/check_credentials.dart';


// Dummy implementations for desktop support.

bool isDesktop(dynamic platformWrapper) => true;
class PlatformWrapper {}

/// Example implementation of createSurveyFilename().

Future<String> createSurveyFilename() async {
  final now = DateTime.now();
  final formatter = DateFormat('yyyyMMddTHHmmss');
  final timestamp = formatter.format(now);
  return 'survey_$timestamp.ttl';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // *** KEY CHANGE: Await the future returned by SharedPreferences.getInstance() ***
  
  final SharedPreferences prefs = await SharedPreferences.getInstance();


  final surveyFilename = await createSurveyFilename();

  // Desktop support (if needed).
  if (!kIsWeb && isDesktop(PlatformWrapper())) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      alwaysOnTop: true,
      title: 'MS Fatigue',
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setAlwaysOnTop(false);
    });
  }

  runApp(
    BlocProvider(
      create: (_) => SurveyBloc(surveyFilename: surveyFilename, sharedPreferences: prefs),
      child: const MSFatigue(),
    ),
  );
}

class MSFatigue extends StatelessWidget {
  const MSFatigue({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MS Fatigue',
      debugShowCheckedModeBanner: false,
      home: CheckCredentials(),
    );
  }
}
