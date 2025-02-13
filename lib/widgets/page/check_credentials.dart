import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/welcome.dart';
import 'package:msfatigue/widgets/page/credentials_page.dart';

class CheckCredentials extends StatefulWidget {
  const CheckCredentials({super.key});

  @override
  State<CheckCredentials> createState() => _CheckCredentialsState();
}

class _CheckCredentialsState extends State<CheckCredentials> {
  Future<bool> _loadCredentialsExist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('msfatigue_username');
    final password = prefs.getString('msfatigue_password');
    final preferredName = prefs.getString('msfatigue_preferredName');
    return (username != null && password != null && preferredName != null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loadCredentialsExist(),
      builder: (context, snapshot) {
        // While waiting for the Future to complete, show a progress indicator.

        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // If an error occurred, display it.

        else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }
        // Once the Future completes, check the credentials.

        else {
          final credentialsExist = snapshot.data ?? false;
          if (!credentialsExist) {
            // If credentials are missing, show a message with a button.

            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Please enter your username, password, and preferred name.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (_) => const CredentialsPage(),
                        ))
                            .then((_) {
                          // After returning, rebuild to re-check credentials.

                          setState(() {});
                        });
                      },
                      child: const Text("Enter Credentials"),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // If credentials exist, go to the WelcomeScreen.

            return const WelcomeScreen();
          }
        }
      },
    );
  }
}
