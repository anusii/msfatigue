import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/welcome.dart';

class PersonalSettings extends StatefulWidget {
  const PersonalSettings({super.key});

  @override
  State<PersonalSettings> createState() => _PersonalSettingsState();
}

class _PersonalSettingsState extends State<PersonalSettings> {
  String? username;
  String? password;
  String? preferredName;

  /// Controls whether the password is shown in plain text.
  
  bool _showPassword = false;

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

  /// Clears the stored credentials and returns the user to [WelcomeScreen].
  
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

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  /// Formats the preferred name so that the first letter is uppercase and the rest are lowercase.
  
  String formatPreferredName(String name) {
    if (name.isEmpty) return name;
    if (name.length == 1) return name.toUpperCase();
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if all credentials are present.

    final bool allCredentialsPresent =
        (username != null && username!.isNotEmpty) &&
        (password != null && password!.isNotEmpty) &&
        (preferredName != null && preferredName!.isNotEmpty);

    // Decide how to display the password:
    //  - If null or empty => "Not set"
    //  - Otherwise => masked by default (******) or show in plain text.

    String passwordDisplay;
    if (password == null || password!.isEmpty) {
      passwordDisplay = "Not set";
    } else {
      passwordDisplay = _showPassword ? password! : "******";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text('Account Details'),
        ),
        elevation: 0,
        toolbarHeight: 125,
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  "Username:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  username ?? "Not set",
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 24),

                const Text(
                  "Password:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                // Row that contains the masked/unmasked password + eye icon.

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SelectableText(
                        passwordDisplay,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    // Eye icon toggles _showPassword.

                    IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade700,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  "Preferred Name:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  (preferredName == null || preferredName!.isEmpty)
                      ? "Not set"
                      : formatPreferredName(preferredName!),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),

                // Clear Credentials button is only shown if all credentials are present.

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
        ),
      ),
    );
  }
}
