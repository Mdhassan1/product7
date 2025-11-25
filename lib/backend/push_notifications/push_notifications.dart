import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Top-level background handler (must be outside the class)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('📥 Background message: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
}

class PushNotifications {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Android notification channel
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications.',
    importance: Importance.high,
  );

  static Future<void> init() async {
    try {
      print('🟡 [DEBUG 1] Starting PushNotifications.init...');

      // 1) Initialize local notifications
      print('🟡 [DEBUG 2] Initializing local notifications...');
      const AndroidInitializationSettings androidInit =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosInit =
          DarwinInitializationSettings();
      const InitializationSettings initSettings =
          InitializationSettings(android: androidInit, iOS: iosInit);

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (resp) {
          debugPrint('🔔 Local notification tapped: ${resp.payload}');
        },
      );
      print('🟡 [DEBUG 3] Local notifications initialized successfully');

      // 2) Create Android channel BEFORE requesting token
      print('🟡 [DEBUG 4] Creating Android notification channel...');
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
      print('🟡 [DEBUG 5] Android notification channel created successfully');

      // 3) Background handler
      print('🟡 [DEBUG 6] Setting up background message handler...');
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      print('🟡 [DEBUG 7] Background message handler set up');

      // 4) Ask user permission (Android 13+ / iOS)
      print('🟡 [DEBUG 8] Requesting notification permissions...');
      final settings = await _messaging.requestPermission();
      debugPrint('🔔 permission: ${settings.authorizationStatus}');
      print(
          '🟡 [DEBUG 9] Permission request completed: ${settings.authorizationStatus}');

      // 5) Get FCM token - THIS IS WHERE IT CRASHES!
      print('🟡 [DEBUG 10] Attempting to get FCM token...');
      final token = await _messaging.getToken();
      print('🟡 [DEBUG 11] FCM token obtained successfully: $token');

      if (token != null) {
        print('🟡 [DEBUG 12] Token is not null, proceeding to save...');
        debugPrint('🟢 FCM token during init: $token');

        // Save token to Supabase if user is logged in
        final supabase = Supabase.instance.client;
        final userId = supabase.auth.currentUser?.id;
        print('🟡 [DEBUG 13] User ID: $userId');

        if (userId != null && token != null) {
          try {
            print('🟡 [DEBUG 14] Attempting to save token to Supabase...');
            await supabase.from('profile').update({
              'fcm_token': token,
            }).eq('user_id', userId);
            debugPrint('✅ FCM token saved during init for user: $userId');
            print('🟡 [DEBUG 15] Token saved to Supabase successfully');
          } catch (e) {
            debugPrint('❌ Error saving FCM token during init: $e');
            print('🟡 [DEBUG 16] Error saving to Supabase: $e');
          }
        } else {
          print(
              '🟡 [DEBUG 17] User ID is null or token is null, skipping Supabase save');
        }
      } else {
        print('🟡 [DEBUG 18] FCM token is NULL');
      }

      // 6) Refresh token listener
      print('🟡 [DEBUG 19] Setting up token refresh listener...');
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        debugPrint('♻️ Token refreshed: $newToken');
        final currentUserId = Supabase.instance.client.auth.currentUser?.id;
        if (currentUserId != null && newToken != null) {
          try {
            await Supabase.instance.client.from('profile').update({
              'fcm_token': newToken,
            }).eq('user_id', currentUserId);
            debugPrint(
                '♻️ FCM token updated in Supabase for user: $currentUserId');
          } catch (e) {
            debugPrint('❌ Error updating refreshed token: $e');
          }
        }
      });
      print('🟡 [DEBUG 20] Token refresh listener set up');

      // 7) Foreground message handler
      print('🟡 [DEBUG 21] Setting up foreground message handler...');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('📩 Foreground message: ${message.messageId}');
        debugPrint('Title: ${message.notification?.title}');
        debugPrint('Body: ${message.notification?.body}');

        final notification = message.notification;
        if (notification != null) {
          _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                importance: Importance.high,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
              ),
              iOS: const DarwinNotificationDetails(),
            ),
            payload: message.data.isNotEmpty ? message.data.toString() : null,
          );
        }
      });
      print('🟡 [DEBUG 22] Foreground message handler set up');

      print('✅ PushNotifications.init completed successfully!');
    } catch (e, stackTrace) {
      print('❌ PushNotifications.init CRASHED!');
      print('🔴 ERROR: $e');
      print('🔴 STACK TRACE: $stackTrace');

      // Detailed error analysis
      if (e.toString().contains('SERVICE_NOT_AVAILABLE')) {
        print('🔴 ROOT CAUSE: FCM Service Not Available');
        print('🔴 POSSIBLE FIXES:');
        print('   1. Check Google Play Services on device');
        print('   2. Verify Firebase configuration');
        print('   3. Test on physical device instead of emulator');
        print('   4. Check internet connection');
      }
    }
  }

  // Additional debug method to test FCM separately
  static Future<void> testFCMToken() async {
    try {
      print('🟡 [FCM TEST] Starting FCM token test...');
      final token = await _messaging.getToken();
      print('🟡 [FCM TEST] Token: $token');
      print('✅ [FCM TEST] Completed successfully');
    } catch (e, stackTrace) {
      print('❌ [FCM TEST] Failed: $e');
      print('🔴 [FCM TEST] Stack: $stackTrace');
    }
  }
}
