import 'package:flutter/material.dart';

import 'package:msfatigue/constants/layout.dart';
import 'package:msfatigue/constants/style.dart';
import 'package:msfatigue/widgets/dialog/show_file_content.dart';

/// A widget that displays a list of files. When a file row is tapped,
/// a dialog is shown with the file's content.
class FileRow extends StatefulWidget {
  final List<String> files;

  const FileRow({
    required this.files,
    super.key,
  });

  @override
  State<FileRow> createState() => _FileRowState();
}

class _FileRowState extends State<FileRow> {
  @override
  Widget build(BuildContext context) {
    if (widget.files.isEmpty) {
      return const Text('No files available.');
    }

    return Column(
      children: widget.files.map((file) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () => showFileContent(file, context),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file),
                horizontalMediumSpace(),
                Text(
                  file,
                  style: textStyle,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
