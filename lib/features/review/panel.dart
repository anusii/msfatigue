import 'package:flutter/material.dart';

class ReviewPanel extends StatefulWidget {
  const ReviewPanel({super.key});

  @override
  State<ReviewPanel> createState() => _ReviewPanelState();
}

class _ReviewPanelState extends State<ReviewPanel> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Review'),
    );
  }
}
