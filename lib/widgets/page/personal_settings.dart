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

  // For toggling password on this screen (outside the dialog).

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('msfatigue_username');
      password = prefs.getString('msfatigue_password');
      preferredName = prefs.getString('msfatigue_preferredName');
    });
  }

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

  Future<void> _showUpdateDialog() async {
    final usernameController = TextEditingController(text: username ?? "");
    final passwordController = TextEditingController(text: password ?? "");
    final preferredNameController =
        TextEditingController(text: preferredName ?? "");

    final updated = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        bool localShowPassword = false;
        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            return AlertDialog(
              title: const Text("Update Details"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: "Username"),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            localShowPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setStateDialog(() {
                              localShowPassword = !localShowPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: !localShowPassword,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: preferredNameController,
                      decoration:
                          const InputDecoration(labelText: "Preferred Name"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString(
                      'msfatigue_username',
                      usernameController.text.trim(),
                    );
                    await prefs.setString(
                      'msfatigue_password',
                      passwordController.text.trim(),
                    );
                    await prefs.setString(
                      'msfatigue_preferredName',
                      preferredNameController.text.trim(),
                    );

                    if (!mounted) return;
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );

    if (updated == true && mounted) {
      // After the user taps "Update," reload credentials to reflect changes.

      await _loadCredentials();

      // The user remains on this page to review updates (no navigation).
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool allCredentialsPresent =
        (username != null && username!.isNotEmpty) &&
            (password != null && password!.isNotEmpty) &&
            (preferredName != null && preferredName!.isNotEmpty);

    // Display for password (****** or actual text).

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
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WelcomeScreen(),
                ),
              ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Clear Credentials button
                    if (allCredentialsPresent)
                      ElevatedButton(
                        onPressed: _clearCredentials,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.red, width: 2),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Clear Details",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ),

                    if (allCredentialsPresent) const SizedBox(width: 16),

                    // Update Credentials button.

                    ElevatedButton(
                      onPressed: _showUpdateDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.blue, width: 2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Update Details",
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Support:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                    'If you are experiencing any issues with the app, or need any support please contact, xxx@anu.edu.au'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
