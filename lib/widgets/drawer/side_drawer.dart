import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart';

import 'package:msfatigue/consent_settings.dart';
import 'package:msfatigue/constants/layout.dart';
import 'package:msfatigue/main.dart';

/// A custom drawer for the MSFatigue app that includes a logo, settings menu,
/// and a logout button. Handles reopening the drawer after navigating back
/// from the ConsentSettingsPage.
///
class SideDrawer extends StatelessWidget {
  /// A global key that manages the state of the parent Scaffold, allowing us
  /// to open the drawer programmatically after returning from another page.

  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideDrawer({
    super.key,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              /// Custom header section. Shows msFatigue_icon.png centered
              /// and a close button on the top-right.

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

              /// Section label: “SETTINGS”.

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

              ListTile(
                title: const Text('Personal settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context); // Closes the drawer.
                },
              ),
              const Divider(
                height: 2,
                color: Colors.black,
              ),

              /// Menu item: Account details.

              ListTile(
                title: const Text('Account details'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context); // Closes the drawer.
                  // 2) Push the new ConsentSettingsPage.

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConsentSettingsPage(),
                    ),
                  );

                  // 3) Re-open the drawer when we return.

                  scaffoldKey.currentState?.openDrawer();
                },
              ),
              const Divider(
                height: 2,
                color: Colors.black,
              ),

              /// Menu item: Consent settings.
              /// We close the drawer, navigate to ConsentSettingsPage,
              /// then re-open the drawer when we come back.

              ListTile(
                title: const Text('Consent settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context); // 1) Close the drawer first

                  // 2) Push the new ConsentSettingsPage.

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConsentSettingsPage(),
                    ),
                  );

                  // 3) Re-open the drawer when we return.

                  scaffoldKey.currentState?.openDrawer();
                },
              ),

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
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () async {
                      await logoutPopup(context, const MSFatigue());
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
    );
  }
}
