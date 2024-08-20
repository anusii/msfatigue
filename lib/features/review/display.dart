import 'package:flutter/material.dart';

import 'package:msfatigue/constants/layout.dart';
import 'package:msfatigue/widgets/file/file_row.dart';
import 'package:msfatigue/widgets/title/title.dart';

class ViewDisplay extends StatefulWidget {
  final List<String> files;

  const ViewDisplay({
    required this.files,
    super.key,
  });

  @override
  State<ViewDisplay> createState() => _ViewDisplayState();
}

class _ViewDisplayState extends State<ViewDisplay> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pageTitle('Files'),
          verticalMediumSpace(),
          if (widget.files.isEmpty)
            const Text('No files available.')
          else
            FileRow(files: widget.files)
        ],
      ),
    );
  }
}
