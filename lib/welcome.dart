import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/constants/secrets.dart';
import 'package:msfatigue/questionnaire/consent.dart';
import 'package:msfatigue/widgets/drawer/side_drawer.dart';
import 'package:msfatigue/widgets/page/credentials_page.dart';
import 'package:msfatigue/widgets/image/image.dart';

/// Helper function to format the preferred name:
/// first letter uppercase and the rest lowercase.

String formatPreferredName(String name) {
  if (name.isEmpty) return name;
  if (name.length == 1) return name.toUpperCase();
  return name[0].toUpperCase() + name.substring(1).toLowerCase();
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? preferredName;
  String? username;
  String? password;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      preferredName = prefs.getString('msfatigue_preferredName');
      username = prefs.getString('msfatigue_username');
      password = prefs.getString('msfatigue_password');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Compute the welcome text.

    final welcomeText = (preferredName == null || preferredName!.isEmpty)
        ? "Welcome!"
        : "Welcome ${formatPreferredName(preferredName!)}!";

    // Check if all credentials are present.

    final bool allCredentialsPresent =
        (username != null && username!.isNotEmpty) &&
            (password != null && password!.isNotEmpty) &&
            (preferredName != null && preferredName!.isNotEmpty);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Center(
          child: iconImage,
        ),
        iconTheme: const IconThemeData(size: 50),
      ),
      drawer: SideDrawer(scaffoldKey: scaffoldKey),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: -30,
                              left: 0,
                              child: Image.asset(
                                'assets/images/title_dot_one.png',
                                width: 325,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Center(
                              child: Text(
                                welcomeText,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.pink,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'You\'ve been invited to participate in a fatigue survey for people with multiple sclerosis (MS).',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'The focus of the survey is your recent experiences of fatigue with a focus on how you are feeling \'right now\'.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'The survey should take 10-20 minutes to complete.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 30),

                        // If credentials are present, show the "Take me to the survey" button.

                        if (allCredentialsPresent)
                          Center(
                            child: SizedBox(
                              width: 260,
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Retrieve the stored credentials.

                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final storedUsername =
                                      prefs.getString('msfatigue_username') ??
                                          "";
                                  final storedPassword =
                                      prefs.getString('msfatigue_password') ??
                                          "";

                                  // Allow the preferred name to be anything.
                                  // It is temporarily setted and may be changed later.

                                  // final storedPreferredName = prefs.getString(
                                  //         'msfatigue_preferredName') ??
                                  //     "";

                                  if (storedUsername == expectedUsername &&
                                          storedPassword == expectedPassword
                                      // && storedPreferredName == expectedPreferredName
                                      ) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ConsentScreen(),
                                      ),
                                    );
                                  } else {
                                    // Show a popup dialog if registration details are incorrect.

                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Registration Error"),
                                        content: const Text(
                                            "Your registration details are not recognised.\n\nPlease contact the study team for assistance."),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.pink,
                                    width: 2,
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Take me to the survey ►',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        // If account info is missing, show the informational message and the Register button.

                        if (preferredName == null || preferredName!.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: SizedBox(
                                width: 300,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Informational message for unregistered users.

                                    RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Before',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' you begin the survey please record the registration details '
                                                'you have been provided with:',
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 12),

                                    SizedBox(
                                      width: 300,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (_) =>
                                                const CredentialsPage(),
                                          ))
                                              .then((_) {
                                            // Re-load the credentials after returning.

                                            _loadCredentials();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.pink,
                                            width: 2,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          "Register",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bottom dot image with a small bottom padding.

                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Image.asset(
                      'assets/images/bottom_dot_one.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
