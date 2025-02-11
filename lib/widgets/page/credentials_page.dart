import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/widgets/page/pod_login_web_view.dart';

class CredentialsPage extends StatefulWidget {
  const CredentialsPage({super.key});

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _preferredNameController =
      TextEditingController();

  Future<void> saveCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('msfatigue_username', _usernameController.text);
    await prefs.setString('msfatigue_password', _passwordController.text);
    await prefs.setString(
        'msfatigue_preferredName', _preferredNameController.text);
  }

  Future<Map<String, String?>> getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'msfatigue_username': prefs.getString('msfatigue_username'),
      'msfatigue_password': prefs.getString('msfatigue_password'),
      'msfatigue_preferredName': prefs.getString('msfatigue_preferredName'),
    };
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _preferredNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Credentials"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _preferredNameController,
                decoration: const InputDecoration(
                  labelText: "Preferred Name",
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // Capture the necessary objects from context before the async gap.

                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);

                  await saveCredentials();

                  // Guard all subsequent uses of context with the mounted check.

                  if (!mounted) return;

                  // Use the pre-captured scaffoldMessenger and navigator.

                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Credentials saved")),
                  );

                  // Navigate to the InAppWebView login flow instead of WelcomeScreen.

                  navigator.pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const PodLoginWebView()),
                  );
                },
                child: const Text("Save"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Capture any needed objects before the async gap.

                  final creds = await getCredentials();
                  if (!mounted) return;
                  // Schedule the dialog to be shown in the next frame.

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text("Saved Credentials"),
                          content: Text(
                            "Username: ${creds['msfatigue_username'] ?? 'N/A'}\n"
                            "Password: ${creds['msfatigue_password'] ?? 'N/A'}\n"
                            "Preferred Name: ${creds['msfatigue_preferredName'] ?? 'N/A'}",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
                child: const Text("Show Credentials"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
