import 'package:intl/intl.dart';

String createSurveyFilename() {
  final now = DateTime.now();
  final formatter = DateFormat('yyyyMMddTHHmmss');
  final timestamp = formatter.format(now);

  return 'survey_$timestamp.ttl';
}
