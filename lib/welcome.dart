import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon({
    Key? key,
    required this.icon,
    required this.size,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return gradient.createShader(bounds);
      },
      child: Icon(
        icon,
        size: size,
        color: Colors.white, // The color here is overridden by the shader
      ),
    );
  }
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

      // Overriding the default hamburger icon: fade to grey, smaller size.

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              // icon: const Icon(
              //   Icons.menu,
              //   color: Colors.grey,
              //   size: 30,
              // ),
              icon: GradientIcon(
                icon: Icons.menu,
                size: 30.0,
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),

        title: iconImage, // Our msFatigue icon
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
                              top: -25,
                              left: 0,
                              child: Image.asset(
                                'assets/images/title_dot_one.png',
                                width: 325,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Text(
                              welcomeText,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        MarkdownBody(
                          selectable: true,
                          data:
                              "You've been invited to participate in a fatigue survey for people with multiple sclerosis (MS).",
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 8),

                        MarkdownBody(
                          selectable: true,
                          data:
                              "The focus of the survey is your recent experiences of fatigue with a focus on how you are feeling 'right now'.",
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 8),

                        MarkdownBody(
                          selectable: true,
                          data:
                              'The survey should take 10-20 minutes to complete.',
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // If credentials are present, show the "Continue" button.
                        if (allCredentialsPresent)
                          Center(
                            child: SizedBox(
                              width: 260,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  if (!mounted) return;

                                  final storedUsername =
                                      prefs.getString('msfatigue_username') ??
                                          "";
                                  final storedPassword =
                                      prefs.getString('msfatigue_password') ??
                                          "";

                                  if (storedUsername == expectedUsername &&
                                      storedPassword == expectedPassword) {
                                    if (!mounted) return;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ConsentScreen(),
                                      ),
                                    );
                                  } else {
                                    if (!mounted) return;
                                    showDialog(
                                      context: context,
                                      builder: (dialogCtx) {
                                        return AlertDialog(
                                          title:
                                              const Text("Registration Error"),
                                          content: const Text(
                                            "Your registration details are not recognised.\n\n"
                                            "Please contact the study team for assistance.",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(dialogCtx),
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
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
                                  'Continue ►',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ),
                          ),

                        // If account info is missing, show a message + Register button.

                        if (!allCredentialsPresent)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: 300,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const CredentialsPage(),
                                            ),
                                          )
                                              .then((_) {
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
                  // Bottom image.
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
