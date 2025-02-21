import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidpod/solidpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:msfatigue/features/bloc/survey_bloc.dart';
import 'package:msfatigue/questionnaire/question.dart';
import 'package:msfatigue/widgets/dialog/show_warning.dart';
import 'package:msfatigue/widgets/gradient_icon.dart';
import 'package:msfatigue/widgets/image/image.dart';
import 'package:msfatigue/widgets/drawer/side_drawer.dart';

class WelcomeBackScreen extends StatefulWidget {
  const WelcomeBackScreen({super.key});
  @override
  State<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  String latestUploadDate = '';
  String? _preferredName;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _latestUploadDate();
    _loadPreferredName();
  }

  Future<void> _loadPreferredName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _preferredName = prefs.getString('msfatigue_preferredName');
    });
  }

  String getLatestDate(List<String> filesResources) {
    DateTime? latestDate;
    for (String file in filesResources) {
      try {
        final dateTimeStr = file.split('_')[1].split('.')[0];
        final parts = dateTimeStr.split('T');
        if (parts.length != 2) continue;
        final datePart = parts[0];
        final timePart = parts[1];
        if (datePart.length != 8 || timePart.length != 6) continue;
        final year = int.parse(datePart.substring(0, 4));
        final month = int.parse(datePart.substring(4, 6));
        final day = int.parse(datePart.substring(6, 8));
        final hour = int.parse(timePart.substring(0, 2));
        final minute = int.parse(timePart.substring(2, 4));
        final second = int.parse(timePart.substring(4, 6));
        final date = DateTime.utc(year, month, day, hour, minute, second);
        if (latestDate == null || date.isAfter(latestDate)) {
          latestDate = date;
        }
      } catch (e) {
        continue;
      }
    }
    if (latestDate == null) return '';
    return DateFormat('d MMMM yyyy h:mm a').format(latestDate.toLocal());
  }

  Future<void> _latestUploadDate() async {
    try {
      final dirUrl = await getDirUrl('msfatigue/data');
      final resources = await getResourcesInContainer(dirUrl);
      final filesResources = resources.files;
      setState(() {
        latestUploadDate = getLatestDate(filesResources);
      });
    } catch (e) {
      setState(() {
        final now = DateTime.now();
        latestUploadDate = DateFormat('d MMMM yyyy h:mm a').format(now);
      });
    }
  }

  int _findFirstUnansweredIndex(
      Map<String, String?> responses, List<String> questionList) {
    for (int i = 0; i < questionList.length; i++) {
      final answer = responses[questionList[i]];
      if (answer == null || answer.isEmpty) {
        return i;
      }
    }
    return questionList.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    final surveyBloc = context.read<SurveyBloc>();
    final surveyState = surveyBloc.state;
    final dataResponses = surveyState.responses;
    final bool hasPartialData =
        dataResponses.values.any((r) => r != null && r.isNotEmpty);
    final userNameString = (_preferredName == null || _preferredName!.isEmpty)
        ? ""
        : ", $_preferredName";
    final greetingText = "Welcome back$userNameString!";

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: GradientIcon(
                icon: Icons.menu,
                size: 40.0,
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey.shade50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        automaticallyImplyLeading: false,
        title: iconImage,
        iconTheme: const IconThemeData(size: 40, color: Colors.grey),
      ),
      drawer: SideDrawer(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  greetingText,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.pink.shade50),
              child: Text(
                hasPartialData
                    ? 'Partial survey saved.\nIt can be resumed until midnight.'
                    : latestUploadDate.isNotEmpty
                        ? 'Survey last completed: $latestUploadDate'
                        : 'Survey not submitted yet.',
                style: const TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 320,
              child: ElevatedButton(
                onPressed: () {
                  final int firstUnanswered = _findFirstUnansweredIndex(
                      dataResponses, surveyState.questionList);
                  surveyBloc.add(SetQuestionIndex(firstUnanswered));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuestionPage(savedResponses: dataResponses),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Container(
                  width: 330,
                  height: 46,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF85E2), Color(0xFFFF5A5F)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Take me to the survey',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 320,
              height: 46,
              child: OutlinedButton(
                onPressed: () {
                  showWarning(
                    'Take Care',
                    "When you are ready you can always come back to the survey.",
                    context,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  side: const BorderSide(color: Colors.pink),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "I'm too tired to do the survey today",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Image.asset(
              'assets/images/bottom_dot_three.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
