import 'package:flutter/material.dart';

class HistoryPanel extends StatefulWidget {
  const HistoryPanel({super.key});

  @override
  State<HistoryPanel> createState() => _HistoryPanelState();
}

class _HistoryPanelState extends State<HistoryPanel> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('History'),
    );
  }
}
