import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart';

import 'package:msfatigue/constants/layout.dart';
import 'package:msfatigue/main.dart';
import 'package:msfatigue/widgets/page/account_details.dart';
import 'package:msfatigue/widgets/page/consent_settings.dart';
import 'package:msfatigue/widgets/page/personal_settings.dart';
import 'package:msfatigue/widgets/image/image.dart';

import 'package:package_info_plus/package_info_plus.dart';

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
  String _appName = 'Unknown';
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
      _appName = info.appName;
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
                    applicationName: _appName,
                    applicationVersion: _appVersion,
                    applicationLegalese: '© 2025 ANU',
                    children: [
                      const Text(
                        "\nThis app demonstrates an MS Fatigue Survey.\n\n"
                        "Authors: Graham Williams and Zheyuan Xu\n"
                        "Licenses: This app is distributed under MIT license.\n",
                      ),
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
