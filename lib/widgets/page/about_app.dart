import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appVersion = "0.1.0"; // Example version
    const authors = "ANU Study Team";
    const description = "A demonstration of an MS Fatigue Survey application.";

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("About the app")),
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
            Text(
              "Version: $appVersion",
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
            // Example reference to PersonalSettings
            const Text(
              "Need to update your credentials? You can do so in:",
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
