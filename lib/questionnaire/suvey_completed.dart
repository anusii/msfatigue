import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:msfatigue/widgets/drawer/side_drawer.dart';
import 'package:msfatigue/widgets/image/image.dart';

class SurveyCompleted extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  SurveyCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: iconImage,
        centerTitle: true,
        iconTheme: const IconThemeData(
          size: 40,
          color: Colors.grey,
        ),
      ),
      drawer: SideDrawer(scaffoldKey: scaffoldKey),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(30),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: const Text(
                "Thank you - Your survey has been saved. You can complete another survey tomorrow (i.e., after midnight tonight).",
                style: TextStyle(
                  fontSize: 22,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Image.asset(
              'assets/images/bottom_dot_six.png',
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
