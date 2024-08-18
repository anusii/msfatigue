import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:msfatigue/constants/layout.dart';
import 'package:solidpod/solidpod.dart';

Future<void> showAbout(BuildContext context, {String? webId}) async {
  final appInfo = await getAppNameVersion();

  if (context.mounted) {
    showAboutDialog(
      context: context,
      applicationLegalese: '© 2024 Software Innovation Institute ANU',
      applicationIcon: Image.asset(
        'assets/images/image.png',
        width: 100,
        height: 100,
      ),
      applicationName: appInfo.name,
      applicationVersion: appInfo.version,
      children: [
        SizedBox(
          // Limit the width of the about dialog box.

          width: 300,

          child: Column(
            children: [
              verticalMediumSpace(context),
              const MarkdownBody(
                selectable: true,
                data: '''
**MS Fatigue App.**

**Authors**: Graham Williams, Zheyuan Xu.
''',
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
