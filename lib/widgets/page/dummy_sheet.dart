import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_markdown/flutter_markdown.dart';

class DummySheet extends StatefulWidget {
  const DummySheet({super.key});

  @override
  State<DummySheet> createState() => _DummySheetState();
}

class _DummySheetState extends State<DummySheet> {
  String? participantMd;

  @override
  void initState() {
    super.initState();
    _loadParticipantSheet();
  }

  Future<void> _loadParticipantSheet() async {
    final mdString =
        await rootBundle.loadString('assets/markdown/participant.md');
    if (!mounted) return;
    setState(() {
      participantMd = mdString;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Information Sheet"),
      ),
      body: participantMd == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(
                data: participantMd!,
                selectable: true,
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 16.0),
                ),
              ),
            ),
    );
  }
}
