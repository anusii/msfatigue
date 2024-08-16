import 'package:flutter/material.dart';

class NormalElevatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonStr;

  const NormalElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonStr,
  });

  @override
  State<NormalElevatedButton> createState() => _NormalElevatedButtonState();
}

class _NormalElevatedButtonState extends State<NormalElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: () {
          widget.onPressed();
        },
        child: Text(
          widget.buttonStr,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
