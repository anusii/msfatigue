import 'package:flutter/material.dart';

import 'package:msfatigue/widgets/drawer/side_drawer.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PersonalSettings extends StatefulWidget {
  const PersonalSettings({super.key});

  @override
  State<PersonalSettings> createState() => _PersonalSettingsState();
}

class _PersonalSettingsState extends State<PersonalSettings> {
  String? username;
  String? password;
  String? preferredName;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  /// Loads the stored credentials from SharedPreferences.

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('msfatigue_username');
      password = prefs.getString('msfatigue_password');
      preferredName = prefs.getString('msfatigue_preferredName');
    });
  }

  /// Clears the stored credentials.

  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('msfatigue_username');
    await prefs.remove('msfatigue_password');
    await prefs.remove('msfatigue_preferredName');
    setState(() {
      username = null;
      password = null;
      preferredName = null;
    });
  }

  /// Formats the preferred name so that the first letter is uppercase and the rest are lowercase.

  String formatPreferredName(String name) {
    if (name.isEmpty) return name;
    if (name.length == 1) return name.toUpperCase();
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the welcome text.

    final welcomeText = (preferredName == null || preferredName!.isEmpty)
        ? "Welcome to the Survey!"
        : "Welcome ${formatPreferredName(preferredName!)}!";

    // Determine if all credentials are present.

    final bool allCredentialsPresent =
        (username != null && username!.isNotEmpty) &&
            (password != null && password!.isNotEmpty) &&
            (preferredName != null && preferredName!.isNotEmpty);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
        backgroundColor: Colors.white,
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
        elevation: 0,
        toolbarHeight: 80,
      ),
      drawer: SideDrawer(scaffoldKey: GlobalKey<ScaffoldState>()),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                welcomeText,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Username:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 4),
            SelectableText(
              username ?? "Not set",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 24),
            const Text(
              "Password:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 4),
            SelectableText(
              password ?? "Not set",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 24),
            const Text(
              "Preferred Name:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 4),
            SelectableText(
              (preferredName == null || preferredName!.isEmpty)
                  ? "Not set"
                  : formatPreferredName(preferredName!),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const Spacer(),
            // Only show the "Clear Credentials" button if all credentials are present.
            
            if (allCredentialsPresent)
              Center(
                child: ElevatedButton(
                  onPressed: _clearCredentials,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.red, width: 2),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Clear Credentials",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
