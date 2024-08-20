import 'package:flutter/material.dart';

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
          child: Row(
            children: [
              const Icon(Icons.insert_drive_file),
              const SizedBox(width: 8),
              Text(
                file,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
