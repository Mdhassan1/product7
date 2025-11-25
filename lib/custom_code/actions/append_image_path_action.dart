// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<String>> appendImagePathAction(
  List<String> existingPaths,
  String newPath,
) async {
  final updatedPaths = List<String>.from(existingPaths);
  updatedPaths.add(newPath);
  return updatedPaths;
}
