import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart';

import 'package:msfatigue/features/history/panel.dart';
import 'package:msfatigue/features/survey/panel.dart';
import 'package:msfatigue/main.dart';

// Define the [NavigationRail] tabs for the home page.

final List<Map<String, dynamic>> homeTabs = [
  {
    'title': 'Survey',
    'icon': Icons.question_answer_rounded,
    'widget': const SurveyPanel(),
  },
  {
    'title': 'History',
    'icon': Icons.history,
    'widget': const HistoryPanel(),
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
              color: Colors.deepPurple,
            ),
            tooltip: 'Logout of your MS Fatigue Survey.',
            onPressed: () async => logoutPopup(context, const MSFatigue()),
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
