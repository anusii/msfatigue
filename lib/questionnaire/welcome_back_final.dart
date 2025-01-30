import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

import 'package:msfatigue/consent_settings.dart';
import 'package:msfatigue/constants/layout.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class WelcomeBackFinalPage extends StatelessWidget {
  const WelcomeBackFinalPage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('d MMMM yyyy').format(today);

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
              Image.asset(
                'assets/images/msFatigue_icon.png',
                height: 65,
              ),
            ],
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
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Custom header section replacing the old [DrawerHeader].
                /// Includes a placeholder logo, title, and a close button.

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 80,
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/msFatigue_icon.png',
                            height: 80,
                          ),
                        ),
                        // Pin the IconButton to the top-right corner.

                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 40,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Optional section label for clarity (e.g., “SETTINGS”).

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      'SETTINGS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
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
                const Divider(
                  height: 2,
                  color: Colors.black,
                ),

                /// Menu item: Account details.
                /// Replace the onTap with navigation logic as needed.

                ListTile(
                  title: const Text('Account details'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(context); // Closes the Drawer.
                  },
                ),
                const Divider(
                  height: 2,
                  color: Colors.black,
                ),

                ListTile(
                  title: const Text('Consent settings'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    // 1) Close the drawer first.

                    Navigator.pop(context);

                    // 2) Push the new ConsentSettingsPage.

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConsentSettingsPage(),
                      ),
                    );

                    // 3) Re-open the drawer when we return.
                    
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),

                /// Use Spacer to push the logout button to the bottom of the Drawer.

                const Spacer(),

                /// Logout button at the bottom of the Drawer.

                Center(
                  child: SizedBox(
                    width: 250,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.grey, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.pop(
                            context); // Close the Drawer or perform logout.
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                verticalMediumSpace(),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Welcome back, Jenny!",
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
                      "Next survey available $formattedDate",
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
