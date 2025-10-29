# Survey for MS Fatigue Assessment

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

[![GitHub](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/anusii/msfatigue)
[![GitHub License](https://img.shields.io/github/license/anusii/msfatigue)](https://github.com/anusii/msfatigue?tab=GPL-3.0-1-ov-file)
[![Flutter Version](https://img.shields.io/badge/dynamic/yaml?url=https://raw.githubusercontent.com/anusii/msfatigue/master/pubspec.yaml&query=$.version&label=version)](https://github.com/anusii/msfatigue/blob/dev/CHANGELOG.md)
[![Last Updated](https://img.shields.io/github/last-commit/anusii/msfatigue?label=last%20updated)](https://github.com/anusii/msfatigue/commits/dev/)
[![GitHub commit activity (dev)](https://img.shields.io/github/commit-activity/w/anusii/msfatigue/dev)](https://github.com/anusii/msfatigue/commits/dev/)
[![GitHub Issues](https://img.shields.io/github/issues/anusii/msfatigue)](https://github.com/anusii/msfatigue/issues)

MSFatigue is a demonstrator app designed to conduct surveys while
saving personal responses to the user's Pod hosted in their Data Vault
on any [Solid Server](https://solidproject.org/about) of choice. The
participant can then choose to share the survey results with the
researcher(s).  The results remain withthe participant, and could be
shared with other researchers in the future. The app was implemented
by the [ANU Software Innovation Institute](https://sii.anu.edu.au) and
written by [Zheyuan Xu](https://github.com/zheyxu) and [Graham
Williams](https://github.com/gjwgit) with design by Susan Hansen and
Michelle Pickrell.

If you appreciate the app then please show some ❤️ and star the [GitHub
Repository](https://github.com/anusii/msfatigue) to support the project.

The latest version of the app can be run online at
[msfatigue.solidcommunity.au](https://msfatigue.solidcommunity.au) with no
installation required, or downloaded and installed for your platform
from the [Solid Community AU](https://solidcommunity.au) repository:

+ **Android**
[apk](https://solidcommunity.au/installers/msfatigue.apk);
+ **GNU/Linux**
[snap](https://solidcommunity.au/installers/msfatigue_amd64.snap) or
[deb](https://solidcommunity.au/installers/msfatigue_amd64.deb) or
[zip](https://solidcommunity.au/installers/msfatigue-dev-linux.zip);
+ **macOS**
[dmg](https://solidcommunity.au/installers/msfatigue-dev-macos-unsigned.dmg) or
[zip](https://solidcommunity.au/installers/msfatigue-dev-macos.zip);
+ **Windows**
[zip](https://solidcommunity.au/installers/msfatigue-dev-windows.zip) or
[inno](https://solidcommunity.au/installers/msfatigue-dev-windows-inno.exe).

Contributions are welcome. Visit
[github](https://github.com/anusii/msfatigue) to submit an issue or,
even better, fork the repository yourself, update the code, and submit
a Pull Request. The app is implemented in
[Flutter](https://flutter.dev) using
[solidpod](https://pub.dev/packages/solidpod) for Flutter to manage
the Solid Pod interactions. Thank you.

## Introduction

On starting up the app you are greeted with the Welcome screen:

![Welcome Screen](assets/screenshots/welcome_iphone_border.png)

The About screen provides some of the background to the project:

![About Screen](assets/screenshots/about_iphone_border.png)

Questions are presented, one question per screen, with the options for
the participant to choose the answer. The questions are sourced from a
markdown file, allowing the survey designers to easily update the
questions:

![Question Screen](assets/screenshots/question_iphone_border.png)

Once the survey has been completed you will be presented with the
Appreciation screen:

![Appreciation Screen](assets/screenshots/splash_iphone_border.png)

<!-- markdownlint-disable MD036 -->
*Time-stamp: <Wednesday 2025-10-29 15:48:39 +1100 Graham Williams>*
<!-- markdownlint-enable MD036 -->

<!-- markdownlint-disable MD053 -->
[comment]: # (Local Variables:)
[comment]: # (time-stamp-line-limit: -8)
[comment]: # (End:)
<!-- markdownlint-enable MD053 -->
