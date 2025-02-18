import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

import 'package:msfatigue/constants/layout.dart';
import 'package:msfatigue/main.dart';
import 'package:msfatigue/welcome.dart';
import 'package:msfatigue/widgets/page/account_details.dart';
import 'package:msfatigue/widgets/page/consent_settings.dart';
import 'package:msfatigue/widgets/page/personal_settings.dart';
import 'package:msfatigue/widgets/image/image.dart';

class SideDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideDrawer({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  String _appVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  /// Load appName and version from pubspec.yaml using package_info_plus.

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      // Combine version and buildNumber if desired, e.g. "0.0.6+4".

      _appVersion = '${info.version}+${info.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              /// Header: msFatigue icon in center, close button top-right.

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 80,
                  child: Stack(
                    children: [
                      Center(child: iconImage),
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
                onTap: () {
                  Navigator.pop(context);

                  // Show an about dialog with appName, version, etc.

                  showAboutDialog(
                    context: context,
                    applicationIcon: iconImage,
                    applicationName: 'MS Fatigue Survey',
                    applicationVersion: 'Version ${_appVersion.split("+")[0]}',
                    applicationLegalese:
                        'Copyright © 2025 ANU\nApp License GPLv3',
                    children: [
                      const Text(
                          "\nThe MS Fatigue app presents a survey to collect data on your experience of fatigue. "
                          "This data will contribute towards our understanding of fatigue amongst people "
                          "affected by multiple sclerosis. We thank you for your important contribution to "
                          "this research.\n\n"
                          "The survery was developed by the ANU's John Curtin School of Medical Research and the research is in "
                          "collaboration with the School of Computing.\n\n"
                          "This app was developed by the ANU's Software Innovation Institute.\n\n"),
                    ],
                  );
                },
              ),

              const Spacer(),

              /// Logout button.

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

                      const MSFatigue(initialScreen: WelcomeScreen());
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
