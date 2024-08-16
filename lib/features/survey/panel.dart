import 'package:flutter/material.dart';

class SurveyPanel extends StatefulWidget {
  const SurveyPanel({super.key});

  @override
  State<SurveyPanel> createState() => _SurveyPanelState();
}

class _SurveyPanelState extends State<SurveyPanel> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Survey'),
    );
  }
}
