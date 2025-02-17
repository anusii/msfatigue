import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart';

import 'package:msfatigue/constants/layout.dart';
import 'package:msfatigue/main.dart';
import 'package:msfatigue/widgets/page/account_details.dart';
import 'package:msfatigue/widgets/page/consent_settings.dart';
import 'package:msfatigue/widgets/page/personal_settings.dart';
import 'package:msfatigue/widgets/page/about_app.dart'; // Import the new AboutApp screen
import 'package:msfatigue/widgets/image/image.dart';

/// A custom drawer for the MSFatigue app that includes a logo, settings menu,
/// and a logout button.
class SideDrawer extends StatelessWidget {
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
              /// Header: msFatigue icon centered, close button top-right.

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 80,
                  child: Stack(
                    children: [
                      Center(
                        child: iconImage,
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

              /// SETTINGS label.

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

              /// 1) Personal settings.

              ListTile(
                title: const Text('Personal settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonalSettings(),
                    ),
                  );
                },
              ),
              const Divider(height: 2, color: Colors.black),

              /// 2) Account details.

              ListTile(
                title: const Text('Account details'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountDetails(),
                    ),
                  );
                },
              ),
              const Divider(height: 2, color: Colors.black),

              /// 3) Consent settings.

              ListTile(
                title: const Text('Consent settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConsentSettings(),
                    ),
                  );
                },
              ),
              const Divider(height: 2, color: Colors.black),

              /// 4) About the app.

              ListTile(
                title: const Text('About the app'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context);
                  // Navigate to the AboutApp screen.

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutApp(),
                    ),
                  );
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
                      // Example of your logout flow.

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
