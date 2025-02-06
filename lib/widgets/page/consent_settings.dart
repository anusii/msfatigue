import 'package:flutter/material.dart';

class ConsentSettings extends StatelessWidget {
  const ConsentSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 125,
        // Remove the leading property since we'll add the close button to actions.

        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Image.asset(
            'assets/images/msFatigue_icon.png',
            height: 75,
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        // Add the close button to the actions list (right side).

        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
                size: 40,
              ),
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CONSENT SETTINGS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 30),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Previously agreed consent\n\n',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextSpan(
                    text:
                        'You\'ve been invited to participate in a fatigue survey '
                        'for people with multiple sclerosis (MS).\n\n'
                        'The focus of the survey is your recent experiences of fatigue '
                        'with a focus on how you are feeling \'right now\'.\n\n'
                        'The survey should take 10-20 minutes to complete.\n\n',
                  ),
                  TextSpan(
                    text: 'Withdrawal of consent\n\n',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextSpan(
                    text:
                        'If you would like to withdraw your consent from this study, '
                        'please email xxxx@anu.edu.au',
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
