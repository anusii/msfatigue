import 'package:flutter/material.dart';

import 'package:msfatigue/questionnaire/consent.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),
        ],
        iconTheme: const IconThemeData(
          size: 50,
        ),
      ),

      /// Updated Drawer code following Effective Dart guidelines.

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Custom header section replacing the old [DrawerHeader].
              /// Includes a placeholder logo, title, and a close button.

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Placeholder for your logo or image.

                    Container(
                      width: 40,
                      height: 40,
                      color: Colors.lightBlue,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'FATIGUE',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              /// Optional section label for clarity (e.g., “SETTINGS”).

              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'SETTINGS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              /// Menu item: Personal settings.
              /// Replace the onTap with navigation logic as needed.

              ListTile(
                title: const Text('Personal settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context); // Closes the Drawer.
                },
              ),
              const Divider(height: 1),

              /// Menu item: Account details.
              /// Replace the onTap with navigation logic as needed.

              ListTile(
                title: const Text('Account details'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context); // Closes the Drawer.
                },
              ),
              const Divider(height: 1),

              ListTile(
                title: const Text('Consent settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context); // Closes the Drawer.
                },
              ),

              /// Use Spacer to push the logout button to the bottom of the Drawer.
               
              const Spacer(),

              /// Logout button at the bottom of the Drawer.

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // Closes the Drawer.
                    },
                    child: const Text('Logout'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 10),
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
                              const Text(
                                'Welcome Jenny!',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.pink,
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
                                      builder: (context) =>
                                          const ConsentScreen(),
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
                        ],
                      ),
                    ),
                    // Bottom dot image.
                    Image.asset(
                      'assets/images/bottom_dot_one.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
