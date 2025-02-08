import 'package:flutter/material.dart';

import 'package:msfatigue/welcome.dart';

void showWarning(String title, String content, BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // First exit the dialog.
              // Then pop the current screen and navigate to the welcome screen.

              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
