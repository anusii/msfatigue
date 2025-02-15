import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:msfatigue/questionnaire/welcome_back_final.dart';
import 'package:msfatigue/widgets/drawer/side_drawer.dart';
import 'package:msfatigue/widgets/image/image.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class SurveyCompleted extends StatelessWidget {
  const SurveyCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Center(
          child: Column(
            children: [
              iconImage,
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          size: 50,
        ),
      ),
      drawer: SideDrawer(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(30),
            const Text(
              "Thank you - You can return to the survey any time before midnight.",
              style: TextStyle(
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
            Image.asset(
              'assets/images/bottom_dot_six.png',
              height: 300,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeBackFinalPage(),
                  ),
                );
              },
              child: Container(
                width: 280,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF85E2),
                      Color(0xFFFF5A5F),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
