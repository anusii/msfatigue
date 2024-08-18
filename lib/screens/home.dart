import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart';

import 'package:msfatigue/constants/colors.dart';
import 'package:msfatigue/features/review/panel.dart';
import 'package:msfatigue/features/survey/panel.dart';
import 'package:msfatigue/main.dart';
import 'package:msfatigue/widgets/dialog/show_about.dart';

// Define the [NavigationRail] tabs for the home page.

final List<Map<String, dynamic>> homeTabs = [
  {
    'title': 'Survey',
    'icon': Icons.question_answer_rounded,
    'widget': const SurveyPanel(),
  },
  {
    'title': 'Review',
    'icon': Icons.history,
    'widget': const ReviewPanel(),
  },
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();

    // Create the [tabController] to manage what happens on leaving/entering
    // tabs.

    _tabController = TabController(length: homeTabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_sharp,
              color: iconColor,
            ),
            tooltip: 'Logout of your MS Fatigue Survey.',
            onPressed: () async => logoutPopup(context, const MSFatigue()),
          ),
          IconButton(
            icon: const Icon(
              Icons.info,
              color: iconColor,
            ),
            tooltip: 'Popup the app About dialog.',
            onPressed: () async => showAbout(context),
          ),
        ],
      ),
      body: Row(
        children: [
          SingleChildScrollView(
            child: IntrinsicHeight(
              // Because the height constraint is unbounded, we need to provide a height limit.
              child: NavigationRail(
                selectedIndex: _tabController.index,
                onDestinationSelected: (int index) {
                  setState(() {
                    _tabController.index = index;
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: homeTabs.map((tab) {
                  return NavigationRailDestination(
                    icon: Icon(tab['icon']),
                    label: Text(
                      tab['title'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                  );
                }).toList(),
                selectedLabelTextStyle: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelTextStyle: TextStyle(color: Colors.grey[500]),
              ),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: homeTabs[_tabController.index]['widget'],
          ),
        ],
      ),
    );
  }
}
