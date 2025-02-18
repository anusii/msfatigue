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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            const Gap(30),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: const Text(
                  "Your data matters!\n      Thank you",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/bottom_dot_six.png',
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
