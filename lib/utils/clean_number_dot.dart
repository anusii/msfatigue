/// Helper function to clean the question by removing the number and dot.
/// Example: "1. I am feeling fatigued after physical activity." => "I am feeling fatigued after physical activity."
String cleanNumberDot(String question) {
  // Remove number and dot at the start of the question using regex.
  return question.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();
}
