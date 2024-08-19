import 'package:flutter/material.dart';

import 'package:msfatigue/constants/colors.dart';

class SubmitButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonStr;

  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.buttonStr,
  });

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: iconColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          widget.onPressed();
        },
        child: Text(
          widget.buttonStr,
        ),
      ),
    );
  }
}
