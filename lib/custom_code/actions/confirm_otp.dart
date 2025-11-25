// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> confirmOtp(String token, String email) async {
  final supabase = Supabase.instance.client;
  try {
    final res = await supabase.auth.verifyOTP(
      type: OtpType.email,
      token: token,
      email: email,
    );

    return true;
  } catch (error) {
    return false;
  }
}
