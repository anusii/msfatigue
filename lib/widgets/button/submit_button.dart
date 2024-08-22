import 'package:flutter/material.dart';

import 'package:msfatigue/constants/colors.dart';
import 'package:msfatigue/widgets/dialog/show_warning.dart';

class SubmitButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonStr;
  final String? webId;

  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.buttonStr,
    required this.webId,
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
          backgroundColor: widget.webId == null ? disabledColor : iconColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: widget.webId == null
            ? () {
                showWarning('Warning',
                    'Please first login in to upload survey!', context);
              }
            : () {
                widget.onPressed();
              },
        child: Text(
          widget.buttonStr,
        ),
      ),
    );
  }
}
