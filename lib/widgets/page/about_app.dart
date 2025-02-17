import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

import 'package:msfatigue/widgets/image/image.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  String? appVersion;
  final String authors = "Graham Williams and Zheyuan Xu";
  final String description =
      "Collect surveys to review fatigue with MS.";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  /// Loads version from pubspec.yaml via package_info_plus.

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      // Typically you'd do something like: appVersion = "${packageInfo.version}+${packageInfo.buildNumber}";

      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fallback to "Loading..." if version not yet loaded.

    final displayVersion = appVersion ?? "Loading...";

    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 125,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: iconImage,
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "MS Fatigue Survey App",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Show the loaded version.

            Text(
              "Version: $displayVersion",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            Text(
              "Authors: $authors",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            Text(
              "Description: $description",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            // Example license link.

            const Text(
              "Licenses: © 2025 ANU",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
