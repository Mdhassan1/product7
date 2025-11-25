import 'package:supabase_flutter/supabase_flutter.dart';

Future getOtp(String email) async {
  try {
    print('📧 Sending OTP to: $email');
    
    // Use Supabase.instance directly
    await Supabase.instance.client.auth.signInWithOtp(
      email: email.trim(),
      shouldCreateUser: true,
    );
    
    print('✅ OTP sent successfully');
  } catch (e) {
    print('❌ OTP Error: $e');
    
    // Don't try to reinitialize - it's already initialized
    // The 401 error means the API key is invalid in Supabase
    rethrow;
  }
}