import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/questionnaire/consent.dart';
import 'package:msfatigue/widgets/drawer/side_drawer.dart';
import 'package:msfatigue/widgets/page/credentials_page.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? preferredName;

  @override
  void initState() {
    super.initState();
    _loadPreferredName();
  }

  Future<void> _loadPreferredName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      preferredName = prefs.getString('msfatigue_preferredName');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Compute the welcome text.

    final welcomeText = (preferredName == null || preferredName!.isEmpty)
        ? "Welcome to the Survey!"
        : "Welcome ${formatPreferredName(preferredName!)}!";

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Center(
          child: Image.asset(
            'assets/images/msFatigue_icon.png',
            height: 65,
          ),
        ),
        iconTheme: const IconThemeData(size: 50),
      ),
      drawer: SideDrawer(scaffoldKey: _scaffoldKey),
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
                        Center(
                          child: SizedBox(
                            width: 260,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ConsentScreen(),
                                  ),
                                );
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
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // If account info is missing, show the Register button.

                        if (preferredName == null || preferredName!.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: SizedBox(
                                width: 260,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => const CredentialsPage(),
                                    ))
                                        .then((_) {
                                      // Re-load the preferred name after returning.
                                      _loadPreferredName();
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
                                      borderRadius: BorderRadius.circular(10),
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
                            ),
                          ),
                      ],
                    ),
                  ),
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
