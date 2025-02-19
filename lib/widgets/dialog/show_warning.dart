import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:msfatigue/questionnaire/welcome_back.dart';

void showWarning(String title, String content, BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.health_and_safety,
              size: 24,
              color: Color(0xFFFF79D4),
            ),
            Gap(20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // First exit the dialog.
              // Then pop the current screen and navigate to the welcome screen.

              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const WelcomeBackScreen()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
