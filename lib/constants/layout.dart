import 'package:flutter/material.dart';

/// [verticalMediumSpace] represents medium vertical space between two widgets.
/// The space constraints are used across the app.

SizedBox verticalMediumSpace(BuildContext context) =>
    SizedBox(height: MediaQuery.of(context).size.height * 0.02);
