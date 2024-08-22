import 'package:flutter/material.dart';

import 'package:msfatigue/widgets/button/normal_elevated_button.dart';
import 'package:msfatigue/widgets/title/title.dart';

class RadioQuestion extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? selected;
  final void Function(int?) onChanged;

  const RadioQuestion(
    this.question,
    this.options,
    this.selected,
    this.onChanged, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        leftAlignedBoldString(question),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < options.length; i++)
                    RadioListTile(
                      title: Text(options[i]),
                      value: i,
                      groupValue: selected,
                      onChanged: (val) {
                        onChanged(val);
                      },
                    ),
                ],
              ),
            ),
            NormalElevatedButton(
              onPressed: () {
                onChanged(null);
              },
              buttonStr: 'Reset',
            ),
          ],
        ),
      ],
    );
  }
}

