import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodLoginWebView extends StatefulWidget {
  const PodLoginWebView({super.key});

  @override
  State<PodLoginWebView> createState() => _PodLoginWebViewState();
}

class _PodLoginWebViewState extends State<PodLoginWebView> {
  InAppWebViewController? webViewController;
  String? username;
  String? password;

  /// Loads the credentials from SharedPreferences.
  Future<void> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('msfatigue_username');
      password = prefs.getString('msfatigue_password');
    });
    debugPrint("Loaded credentials: username: $username, password: $password");
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
        // Load the root URL first.
        initialUrlRequest: URLRequest(
          url: WebUri("https://pods.dev.solidcommunity.au/"),
        ),
        initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        // Use onLoadStart to log when loading starts.
        onLoadStart: (controller, url) async {
          debugPrint("🌍 onLoadStart: $url");
        },
        // Use onLoadStop as the primary callback for our login flow.
        onLoadStop: (controller, url) async {
          debugPrint("🌍 onLoadStop: $url");

          // Normalize the URL by removing trailing slashes.
          final currentUrl = url.toString().replaceAll(RegExp(r'/+$'), '');
          debugPrint("Normalized URL: $currentUrl");

          // Step 1: If at root, redirect to the login page.
          if (currentUrl == "https://pods.dev.solidcommunity.au") {
            debugPrint("🔄 Redirecting to login page...");
            await controller.loadUrl(
              urlRequest: URLRequest(
                url: WebUri(
                    "https://pods.dev.solidcommunity.au/.account/login/password/"),
              ),
            );
            return;
          }

          // Step 2: Inject credentials on the login page.
          if (url.toString().contains("/.account/login/password")) {
            debugPrint("✍️ Injecting login credentials...");
            // Ensure username and password variables are available (loaded from SharedPreferences or elsewhere).
            if (username != null && password != null) {
              await controller.evaluateJavascript(source: """
          (function() {
            const emailInput = document.querySelector('input[name="email"]');
            const passwordInput = document.querySelector('input[name="password"]');
            const loginButton = document.querySelector('button[type="submit"]');
            if (emailInput && passwordInput && loginButton) {
              emailInput.value = "$username";
              passwordInput.value = "$password";
              console.log("Credentials injected: " + emailInput.value + ", " + passwordInput.value);
              setTimeout(() => {
                loginButton.click();
              }, 2000);
            } else {
              console.log("One or more elements not found on login page.");
            }
          })();
        """);
            } else {
              debugPrint("❌ Credentials not available for injection.");
            }
            return;
          }

          // Step 3: Handle OAuth consent screen if present.
          if (url.toString().contains("/account/oidc/consent")) {
            debugPrint("🔍 Detected consent screen, clicking 'Yes'...");
            await controller.evaluateJavascript(source: """
        (function() {
          const yesButton = document.querySelector("button#authorize");
          if (yesButton) {
            setTimeout(() => {
              yesButton.click();
            }, 2000);
            console.log("Clicked 'Yes' on consent screen.");
          } else {
            console.log("Consent button not found.");
          }
        })();
      """);
            return;
          }

          // Step 4: Extract WebID from account page.
          if (url.toString().contains("/.account/account")) {
            debugPrint(
                "✅ Login detected at /.account/account/, waiting for DOM...");
            await Future.delayed(const Duration(seconds: 3));
            final extractedWebId =
                await controller.evaluateJavascript(source: """
        (function() {
          const anchor = document.querySelector('#webIdEntries li a');
          if (anchor) {
            return anchor.href;
          }
          return '';
        })();
      """) as String;
            if (extractedWebId.isNotEmpty) {
              debugPrint("🔑 Extracted WebID from HTML: $extractedWebId");
              // Optionally store or use the extracted WebID.
            } else {
              debugPrint("❌ Could not find WebID under #webIdEntries li a!");
            }
          }
        },
      ),
    );
  }
}
