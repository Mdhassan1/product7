// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:typed_data';

Future<String> createUserFolder() async {
  try {
    final folderNameBase = SupaFlow.client.auth.currentUser?.id;

    // Stub for a file (empty binary)
    final Uint8List stubImage = Uint8List.fromList([0, 1, 0, 1, 1]); //

    // Use the stub binary file directly in storage client operations
    await SupaFlow.client.storage.from('profilepics').uploadBinary(
        'profile_pics/$folderNameBase/welcome_user.txt', stubImage);

    // Return success message if upload is successful
    return 'File uploaded successfully!';
  } catch (error_text) {
    // Return error message if any error occurs during upload
    return 'Error uploading file: $error_text';
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
