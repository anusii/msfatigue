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
import 'package:solidpod/solidpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:msfatigue/features/bloc/survey_bloc.dart';
import 'package:msfatigue/welcome.dart';

// Dummy implementations for desktop support.
// Replace these with your actual implementations.

bool isDesktop(dynamic platformWrapper) {
  return true;
}

class PlatformWrapper {
  // Your platform wrapper implementation.
}

// Example implementation of createSurveyFilename().
// Modify this function to generate your filename as needed.

Future<String> createSurveyFilename() async {
  final now = DateTime.now();
  final formatter = DateFormat('yyyyMMddTHHmmss');
  final timestamp = formatter.format(now);

  return 'survey_$timestamp.ttl';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final surveyFilename = await createSurveyFilename();

  // Desktop support (if needed).

  if (!kIsWeb && isDesktop(PlatformWrapper())) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      // Setting alwaysOnTop to true so the app starts on top.
      alwaysOnTop: true,
      title: 'MS Fatigue',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setAlwaysOnTop(false);
    });
  }

  // Ready to run the app.

  runApp(
    BlocProvider(
      create: (_) => SurveyBloc(surveyFilename: surveyFilename),
      child: const MSFatigue(),
    ),
  );
}

class MSFatigue extends StatelessWidget {
  const MSFatigue({super.key});

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MS Fatigue',
      debugShowCheckedModeBanner: false,
      home: SolidLogin(
        image: AssetImage('assets/images/msFatigue_cover_image.png'),
        logo: AssetImage('assets/images/msFatigue_icon.png'),
        webID: 'https://pods.dev.solidcommunity.au',
        child: Scaffold(body: WelcomeScreen()),
      ),
    );
  }
}
