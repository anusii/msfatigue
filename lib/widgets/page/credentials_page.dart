import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialsPage extends StatefulWidget {
  const CredentialsPage({super.key});

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _preferredNameController = TextEditingController();

  Future<void> saveCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('msfatigue_username', _usernameController.text);
    await prefs.setString('msfatigue_password', _passwordController.text);
    await prefs.setString('msfatigue_preferredName', _preferredNameController.text);
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
                  await saveCredentials();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Credentials saved")),
                  );
                  // After saving, navigate back to the previous screen.
                  Navigator.of(context).pop();
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
