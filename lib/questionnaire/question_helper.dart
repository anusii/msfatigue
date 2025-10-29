/// Question page helper functions.
///
// Time-stamp: <Wednesday 2025-10-29 09:50:19 +1100 Graham Williams>
///
/// Copyright (C) 2025, Software Innovation Institute, ANU.
///
/// Licensed under the GNU General Public License, Version 3 (the "License").
///
/// License: https://opensource.org/license/gpl-3-0.
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://opensource.org/license/gpl-3-0>.
///
/// Authors: Graham Williams, Zheyuan Xu

library;

import 'package:flutter/material.dart';

final List<String> options = [
  'Strongly disagree',
  'Disagree',
  'Agree',
  'Strongly agree',
  "Don't know",
  'Not applicable',
];

final List<Color> gradientColors = [
  const Color(0xFFFFE6EB),
  const Color(0xFFFFD6DE),
  const Color(0xFFFFC6D1),
  const Color(0xFFFFB6C5),
  const Color.fromARGB(255, 200, 195, 195),
  const Color.fromARGB(255, 220, 215, 215),
];

List<String> parseQuestions(String data) {
  final lines = data.split('\n');
  final List<String> extracted = [];
  bool isQuestion = false;
  for (var line in lines) {
    if (line.startsWith('## Questions')) {
      isQuestion = true;
    } else if (line.startsWith('## Answer Options')) {
      isQuestion = false;
    } else if (isQuestion && line.trim().isNotEmpty) {
      extracted.add(line.substring(line.indexOf('.') + 2).trim());
    }
  }
  return extracted;
}

pinkGrey(selectedResponse) {
  return (selectedResponse != null && selectedResponse.isNotEmpty)
      ? Colors.pink
      : Colors.grey;
}

darkLightGrey(currentIndex) {
  return (currentIndex > 0) ? Colors.grey[700] : Colors.grey;
}

leftArrow(currentIndex) {
  return Icon(
    Icons.arrow_left,
    color: darkLightGrey(currentIndex),
  );
}

ButtonStyle obStyleEndNow() {
  return OutlinedButton.styleFrom(
    side: const BorderSide(
      color: Colors.pink,
      width: 1.8,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    ),
  );
}

ButtonStyle obStylePrevious(currentIndex) {
  return OutlinedButton.styleFrom(
    side: BorderSide(
      color: darkLightGrey(currentIndex),
      width: 2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 5,
    ),
    alignment: Alignment.centerLeft,
  );
}
