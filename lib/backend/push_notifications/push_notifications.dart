import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Top-level background handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint('📥 BACKGROUND MESSAGE: ${message.messageId}');
  debugPrint('📥 Data: ${message.data}');
  debugPrint('📥 Notification: ${message.notification}');

  // Show local notification for background messages
  await PushNotifications.showBackgroundNotification(message);
}

class PushNotifications {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Create vibration pattern as a static final (not const)
  static final Int64List _vibrationPattern =
      Int64List.fromList([0, 1000, 500, 1000]);

  // Create notification channel without const
  static final AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id - MUST match AndroidManifest.xml
    'High Importance Notifications', // title
    description: 'Used for important product notifications.',
    importance: Importance.high,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound('notification'),
    enableVibration: true,
    vibrationPattern: _vibrationPattern,
    showBadge: true,
    enableLights: true,
  );

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) {
      debugPrint('🔄 PushNotifications already initialized');
      return;
    }

    try {
      debugPrint('🟡 Starting PushNotifications.init...');

      // 1. Initialize local notifications with proper settings
      const AndroidInitializationSettings androidInit =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('🔔 Local notification tapped: ${response.payload}');
          _handleNotificationTap(response.payload);
        },
        onDidReceiveBackgroundNotificationResponse:
            (NotificationResponse response) {
          debugPrint('🔔 Background notification tapped: ${response.payload}');
          _handleNotificationTap(response.payload);
        },
      );

      // 2. Create Android channel (CRITICAL for Android 8+)
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      // 3. Set up background handler
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // 4. Request permissions
      final NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint('🔔 Permission status: ${settings.authorizationStatus}');

      // 5. Configure foreground display options
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 6. Get initial message if app was opened from notification
      final RemoteMessage? initialMessage =
          await _messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
            '🚀 App opened from notification: ${initialMessage.messageId}');
        _handleNotificationOpen(initialMessage);
      }

      // 7. Get initial FCM token
      await _handleInitialToken();

      // 8. Set up token refresh listener
      _messaging.onTokenRefresh.listen((newToken) async {
        debugPrint('♻️ Token refreshed: ${newToken.substring(0, 20)}...');
        if (newToken.isNotEmpty) {
          await _saveFcmToken(newToken);
        }
      });

      // 9. Foreground message handler
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('📩 FOREGROUND MESSAGE: ${message.messageId}');
        debugPrint('📩 Data: ${message.data}');
        debugPrint('📩 Notification: ${message.notification}');
        _handleForegroundMessage(message);
      });

      // 10. Message opened handler
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('🔔 App opened from notification: ${message.messageId}');
        _handleNotificationOpen(message);
      });

      _initialized = true;
      debugPrint('✅ PushNotifications.init completed successfully!');

      // Test notification
      await _testLocalNotification();
    } catch (e, stackTrace) {
      debugPrint('❌ PushNotifications.init error: $e');
      debugPrint('Stack trace: $stackTrace');
      _initialized = false;
    }
  }

  static Future<void> _testLocalNotification() async {
    // Test if local notifications work
    await Future.delayed(const Duration(seconds: 3));
    await _showLocalNotification(
      title: 'Product7 Ready',
      body: 'Push notifications are working correctly!',
      payload: 'test',
    );
    debugPrint('🧪 Test notification sent');
  }

  static Future<void> _handleInitialToken() async {
    try {
      String? token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        debugPrint('🟢 Initial FCM token: ${token.substring(0, 20)}...');
        await _saveFcmToken(token);
      } else {
        debugPrint('⚠️ No initial FCM token received');
      }
    } catch (e) {
      debugPrint('❌ Initial FCM token error: $e');
      await Future.delayed(const Duration(seconds: 5));
      await _handleInitialToken();
    }
  }

  static Future<void> _saveFcmToken(String token) async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId != null && userId.isNotEmpty) {
        await supabase.from('profile').update({
          'fcm_token': token,
        }).eq('user_id', userId);

        debugPrint('✅ FCM token saved for user: $userId');
      } else {
        debugPrint('ℹ️ No user logged in, skipping FCM token save');
      }
    } catch (e, st) {
      debugPrint('❌ Error saving FCM token: $e');
      debugPrint('Stack trace: $st');
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('🎯 Handling foreground message');

    // Check if message has notification payload
    if (message.notification != null) {
      final notification = message.notification!;
      debugPrint('📢 Notification title: ${notification.title}');
      debugPrint('📢 Notification body: ${notification.body}');

      _showLocalNotification(
        title: notification.title ?? 'Notification',
        body: notification.body ?? '',
        payload: message.data.toString(),
      );
    } else if (message.data.isNotEmpty) {
      // Handle data-only messages
      debugPrint('📊 Data-only message: ${message.data}');
      _showLocalNotification(
        title: message.data['title'] ?? 'Notification',
        body: message.data['body'] ?? 'New notification',
        payload: message.data.toString(),
      );
    }
  }

  static void _handleNotificationTap(String? payload) {
    debugPrint('🔔 Notification tapped with payload: $payload');
    // Handle navigation based on payload
  }

  static void _handleNotificationOpen(RemoteMessage message) {
    debugPrint('🔔 App opened from notification: ${message.data}');
    // Handle deep linking
  }

  static Future<void> showBackgroundNotification(RemoteMessage message) async {
    debugPrint('🌙 Showing background notification');

    if (message.notification != null) {
      final notification = message.notification!;
      await _showLocalNotification(
        title: notification.title ?? 'Notification',
        body: notification.body ?? '',
        payload: message.data.toString(),
      );
    } else if (message.data.isNotEmpty) {
      await _showLocalNotification(
        title: message.data['title'] ?? 'Notification',
        body: message.data['body'] ?? 'New notification',
        payload: message.data.toString(),
      );
    }
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      // Create vibration pattern for the notification
      final vibrationPattern = Int64List.fromList([0, 1000, 500, 1000]);

      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'high_importance_channel', // MUST match channel ID
        'High Importance Notifications',
        channelDescription: 'Used for important product notifications.',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notification'),
        enableVibration: true,
        vibrationPattern: vibrationPattern,
        styleInformation: const DefaultStyleInformation(true, true),
        autoCancel: true,
        ongoing: false,
        visibility: NotificationVisibility.public,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        platformDetails,
        payload: payload,
      );

      debugPrint('✅ Local notification shown: $title');
    } catch (e) {
      debugPrint('❌ Error showing local notification: $e');
    }
  }

  // Test FCM functionality
  static Future<void> testFCM() async {
    try {
      final token = await _messaging.getToken();
      debugPrint('🟡 FCM Test - Token: ${token?.substring(0, 20)}...');

      final settings = await _messaging.getNotificationSettings();
      debugPrint('🟡 FCM Test - Settings: $settings');

      // Send test notification
      await _showLocalNotification(
        title: 'FCM Test',
        body: 'If you see this, FCM is working!',
        payload: 'test',
      );

      debugPrint('✅ FCM Test completed');
    } catch (e) {
      debugPrint('❌ FCM Test error: $e');
    }
  }

  static Future<void> updateFcmToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _saveFcmToken(token);
      }
    } catch (e) {
      debugPrint('❌ Manual FCM token update error: $e');
    }
  }
}
