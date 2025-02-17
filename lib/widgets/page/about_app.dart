import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  String? appVersion;
  final String authors = "ANU SII Team";
  final String description = "A demonstration of an MS Fatigue Survey application.";

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
      appBar: AppBar(
        title: const Center(child: Text("About the app")),
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
              description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            const Text(
              "Need to update your credentials? You can do so in the Personal Settings screen.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Example license link.
            
            const Text(
              "Licenses: This app is distributed under the MIT license (example).",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
