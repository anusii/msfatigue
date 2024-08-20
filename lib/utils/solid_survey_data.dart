import 'package:msfatigue/constants/app.dart';
import 'package:solidpod/solidpod.dart';

Future<({List<String> files, List<String> subDirs})> solidSurveyData() async {
  String? webId = await getWebId();

  if (webId != null) {
    String surveyFolderLoc = webId.replaceAll(suffixWebID, solidSurveyDataLoc);

    // Fetch the resources in the container and explicitly type the result as List<String>.
    ({List<dynamic> files, List<dynamic> subDirs}) surveyRecords =
        await getResourcesInContainer(surveyFolderLoc);

    // Cast the dynamic lists to List<String>.
    return (
      files: List<String>.from(surveyRecords.files),
      subDirs: List<String>.from(surveyRecords.subDirs),
    );
  } else {
    // Return empty lists with explicit typing as List<String>.
    return (files: <String>[], subDirs: <String>[]);
  }
}
