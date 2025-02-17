import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart';

import 'package:msfatigue/widgets/image/image.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails({super.key});

  // Helper function to retrieve the Pod URI (webID).

  Future<String> _getWebId() async {
    final id = await getWebId();
    return id ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 125,
        automaticallyImplyLeading: false,
        title: iconImage,
        centerTitle: true,
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
      body: FutureBuilder<String>(
        future: _getWebId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Pod URI found"));
          }

          // Retrieve the Pod URI and derive the current Solid server.

          final podUri = snapshot.data!;
          final Uri parsedUri = Uri.parse(podUri);
          final currentSolidServer = parsedUri.origin;

          // Center the entire content vertically and horizontally.

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  const Text(
                    'ACCOUNT DETAILS',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Solid Server:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          currentSolidServer,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Pod URI:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          podUri,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
