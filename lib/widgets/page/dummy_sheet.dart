import 'package:flutter/material.dart';

class DummySheet extends StatelessWidget {
  const DummySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Information Sheet"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "This is a dummy Participant Information Sheet.\n\n"
          "The screen can be a content or PDF viewer.",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
