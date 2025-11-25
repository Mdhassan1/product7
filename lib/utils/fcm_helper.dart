import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FcmHelper {
  static Future<void> saveTokenToSupabase() async {
    final fcm = FirebaseMessaging.instance;
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;
    if (user == null) return; // no logged in user

    try {
      // 1. Get token
      final token = await fcm.getToken();
      if (token != null) {
        await supabase.from('profile').update({
          'fcm_token': token,
          
        }).eq('user_id', user.id);
      }

      // 2. Listen for refresh
      fcm.onTokenRefresh.listen((newToken) async {
        await supabase.from('profile').update({
          'fcm_token': newToken,
          
        }).eq('user_id', user.id);
      });
    } catch (e) {
      print('❌ Failed to save FCM token: $e');
    }
  }
}
