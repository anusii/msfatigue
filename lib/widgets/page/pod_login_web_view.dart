import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodLoginWebView extends StatefulWidget {
  const PodLoginWebView({super.key});

  @override
  State<PodLoginWebView> createState() => _PodLoginWebViewState();
}

class _PodLoginWebViewState extends State<PodLoginWebView> {
  late InAppWebViewController webViewController;
  String? username;
  String? password;

  /// Load the credentials from SharedPreferences.
  Future<void> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('msfatigue_username');
      password = prefs.getString('msfatigue_password');
    });
  }

  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("POD Login"),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://pods.dev.solidcommunity.au/"),
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          debugPrint("🌍 WebView Loaded: $url");

          // Step 1: If the current URL is the root, redirect to the login page.
          if (url.toString() == "https://pods.dev.solidcommunity.au/") {
            debugPrint("🔄 Redirecting to login page...");
            await controller.loadUrl(
              urlRequest: URLRequest(
                url: WebUri(
                    "https://pods.dev.solidcommunity.au/.account/login/password/"),
              ),
            );
          }

          // Step 2: When the login page loads, inject the credentials.
          if (url.toString().contains("/.account/login/password")) {
            debugPrint("✍️ Injecting login credentials...");
            if (username != null && password != null) {
              await controller.evaluateJavascript(source: """
                let emailInput = document.querySelector('input[name="email"]');
                let passwordInput = document.querySelector('input[name="password"]');
                let loginButton = document.querySelector('button[type="submit"]');
                if (emailInput && passwordInput && loginButton) {
                  emailInput.value = '$username';
                  passwordInput.value = '$password';
                  setTimeout(() => {
                    loginButton.click();
                  }, 2000);
                }
              """);
            } else {
              debugPrint("❌ Credentials not loaded yet.");
            }
          }

          // Additional steps (e.g., handling OAuth consent or extracting WebID) can be added here.
        },
      ),
    );
  }
}
