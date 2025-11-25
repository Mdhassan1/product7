// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

List<String> removeItemFromList(
  List<String> originalList,
  String itemToRemove,
) {
  return originalList
      .where(
        (item) =>
            item.trim().toLowerCase() != itemToRemove.trim().toLowerCase(),
      )
      .toList();
}
