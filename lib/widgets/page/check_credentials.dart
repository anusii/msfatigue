import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/welcome.dart';
import 'package:msfatigue/widgets/page/credentials_page.dart';

/// A widget that checks for stored credentials and routes accordingly.
class CheckCredentials extends StatefulWidget {
  const CheckCredentials({super.key});

  @override
  State<CheckCredentials> createState() => _CheckCredentialsState();
}

class _CheckCredentialsState extends State<CheckCredentials> {
  bool? credentialsExist;

  Future<void> checkCredentials() async {
    // Use SharedPreferences to read stored credentials.

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('msfatigue_username');
    final password = prefs.getString('msfatigue_password');
    final preferredName = prefs.getString('msfatigue_preferredName');

    setState(() {
      credentialsExist =
          (username != null && password != null && preferredName != null);
    });
  }

  @override
  void initState() {
    super.initState();
    checkCredentials();
  }

  @override
  Widget build(BuildContext context) {
    // While checking, show a progress indicator.

    if (credentialsExist == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // If credentials are missing, pop up a dialog then navigate to the CredentialsPage.

    else if (credentialsExist == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Credentials Required"),
            content: const Text(
                "Please enter your username, password, and preferred name."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CredentialsPage(),
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      });
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Please enter your credentials."),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the CredentialsPage.
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const CredentialsPage(),
                ));
              },
              child: const Text("Enter Credentials"),
            ),
          ],
        )),
      );
    }
    // If credentials exist, navigate to the main WelcomeScreen.

    else {
      return const WelcomeScreen();
    }
  }
}
