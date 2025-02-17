import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/questionnaire/welcome_back.dart';
import 'package:msfatigue/widgets/page/dummy_sheet.dart';
import 'package:msfatigue/welcome.dart';
import 'package:msfatigue/widgets/image/image.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool? _consentGiven;
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
    final welcomeText = (preferredName == null || preferredName!.isEmpty)
        ? "Welcome!"
        : "Welcome ${formatPreferredName(preferredName!)}!";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 80,
        title: iconImage,
        iconTheme: const IconThemeData(
          size: 40,
          color: Colors.grey,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Text(
                    welcomeText,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  MarkdownBody(
                    data:
                        'Here is the [Participant Information Sheet](info) for the MS Fatigue Survey.',
                    onTapLink: (text, href, title) {
                      if (href == 'info') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DummySheet(),
                          ),
                        );
                      }
                    },
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(fontSize: 16, color: Colors.black),
                      a: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  MarkdownBody(
                    selectable: true,
                    data:
                        "The ethical aspects of this research have been approved by the ANU Human Research Ethics Committee (2024/0698).",
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  MarkdownBody(
                    selectable: true,
                    data:
                        'I have read the Participant Information Sheet and hereby provide my consent to participate in this study.',
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Yes'),
                    leading: Radio<bool>(
                      value: true,
                      groupValue: _consentGiven,
                      onChanged: (bool? value) {
                        setState(() {
                          _consentGiven = value;
                        });
                      },
                      activeColor: Colors.pink,
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.pink;
                          }
                          return Colors.pink;
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('No'),
                    leading: Radio<bool>(
                      value: false,
                      groupValue: _consentGiven,
                      onChanged: (bool? value) {
                        setState(() {
                          _consentGiven = value;
                        });
                      },
                      activeColor: Colors.pink,
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.pink;
                          }
                          return Colors.pink;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: 260,
                      child: ElevatedButton(
                        onPressed: _consentGiven == true
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const WelcomeBackScreen(),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: _consentGiven == true
                                ? Colors.pink
                                : Colors.grey,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Continue to the survey ►',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _consentGiven == true
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/bottom_dot_two.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
