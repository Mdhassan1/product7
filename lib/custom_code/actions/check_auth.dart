// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> checkAuth() async {
  // Add your function code here!
  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;

  final Session? session = supabase.auth.currentSession;

  if (session != null) {
    print('Signed In!');
    return true;
  } else {
    print('No sign in');
    return false;
  }
}
