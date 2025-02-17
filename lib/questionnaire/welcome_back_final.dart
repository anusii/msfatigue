import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

import 'package:msfatigue/widgets/drawer/side_drawer.dart';
import 'package:msfatigue/widgets/image/image.dart';

class WelcomeBackFinalPage extends StatefulWidget {
  const WelcomeBackFinalPage({super.key});

  @override
  State<WelcomeBackFinalPage> createState() => _WelcomeBackFinalPageState();
}

class _WelcomeBackFinalPageState extends State<WelcomeBackFinalPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    DateTime today = DateTime.now();
    String formattedDate = DateFormat('d MMMM yyyy hh:mm a').format(today);

    String nextAvailableDate = DateFormat('d MMMM yyyy').format(today);

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
          size: 50,
        ),
      ),
      drawer: SideDrawer(scaffoldKey: scaffoldKey),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Welcome back!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Center(
                    child: Text(
                      "Survey last completed: Today ($formattedDate)",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  width: 360,
                  height: 46,
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
                  child: Center(
                    child: Text(
                      "Next survey available $nextAvailableDate",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 360,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle "Too tired" action
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "I’m too tired to complete this survey",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                Image.asset(
                  'assets/images/bottom_dot_seven.png',
                  height: 300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
