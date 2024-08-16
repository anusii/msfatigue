import 'package:flutter/material.dart';

/// A Text Widget of [content] used as the content of body.
/// The text is bold.

Text contentBoldString(String content) {
  return Text(content,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ));
}

/// A left aligned row with a bold string that wraps.
///
/// Wraps the given [content] in a [Text] widget with a bold style
/// inside a [Flexible] widget to allow wrapping. Aligns the [Row]
/// and [Text] to the start to left justify.

Widget leftAlignedBoldString(String content) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Flexible(
        child: contentBoldString(content),
      ),
    ],
  );
}
