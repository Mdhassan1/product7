import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'auth/supabase_auth/supabase_user_provider.dart';
import 'auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import 'backend/firebase/firebase_config.dart';
import 'backend/push_notifications/push_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment
  final environmentValues = FFDevEnvironmentValues();
  await environmentValues.initialize();

  // Initialize Firebase with better error handling
  bool firebaseInitialized = false;
  try {
    await initFirebase();
    firebaseInitialized = true;
    debugPrint('✅ Firebase initialized successfully');
  } catch (e, st) {
    debugPrint('❌ Firebase init error: $e');
    debugPrint('Stack trace: $st');
    // Continue without Firebase - don't crash the app
  }

  // Initialize Supabase
  try {
    await SupaFlow.initialize();
    debugPrint('✅ Supabase initialized successfully');
  } catch (e, st) {
    debugPrint('❌ Supabase init error: $e');
    debugPrint('Stack trace: $st');
    rethrow; // Supabase is critical, rethrow
  }

  // Initialize Push Notifications only if Firebase was initialized
  if (firebaseInitialized) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await PushNotifications.init();
      } catch (e) {
        debugPrint('❌ PushNotifications init error: $e');
      }
    });
  } else {
    debugPrint('⚠️ Skipping PushNotifications init - Firebase not available');
  }

  // Initialize theme
  await FlutterFlowTheme.initialize();

  // Initialize app state
  final appState = FFAppState();
  await appState.initializePersistedState();

  // Set up FCM token management only if Firebase is available
  if (firebaseInitialized) {
    _setupFcmTokenManagement();
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => appState,
      child: const MyApp(),
    ),
  );
}

void _setupFcmTokenManagement() {
  final supabaseClient = Supabase.instance.client;

  // Listen to auth state changes
  supabaseClient.auth.onAuthStateChange.listen((event) async {
    debugPrint('🔄 Auth state changed: ${event.event}');

    final user = supabaseClient.auth.currentUser;
    if (user != null && event.event == AuthChangeEvent.signedIn) {
      debugPrint('👤 User signed in: ${user.id}');

      // Wait a bit then update FCM token with retry logic
      await _updateFcmTokenWithRetry(user.id);
    } else if (event.event == AuthChangeEvent.signedOut) {
      debugPrint('👤 User signed out');
      // Optionally: Remove FCM token from server when user signs out
    }
  });

  // Check for existing user on app start
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final initialUser = supabaseClient.auth.currentUser;
    if (initialUser != null) {
      debugPrint('🔍 Found existing user: ${initialUser.id}');
      await Future.delayed(const Duration(seconds: 3));
      await _updateFcmTokenWithRetry(initialUser.id);
    }
  });
}

Future<void> _updateFcmTokenWithRetry(String userId,
    {int maxRetries = 3}) async {
  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      debugPrint(
          '🔄 Attempting to update FCM token (attempt $attempt/$maxRetries)...');
      await _updateFcmToken(userId);
      return; // Success, exit retry loop
    } catch (e) {
      debugPrint('❌ FCM token update attempt $attempt failed: $e');

      if (attempt == maxRetries) {
        debugPrint('💥 All FCM token update attempts failed');
        return;
      }

      // Exponential backoff
      final delay = Duration(seconds: attempt * 2);
      debugPrint('⏳ Retrying in ${delay.inSeconds} seconds...');
      await Future.delayed(delay);
    }
  }
}

Future<void> _updateFcmToken(String userId) async {
  try {
    // Check if Firebase Messaging is available
    try {
      await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('⚠️ Firebase Messaging not available: $e');
      return;
    }

    // Get FCM token
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null && fcmToken.isNotEmpty) {
      debugPrint('🟢 FCM Token retrieved: ${fcmToken.substring(0, 20)}...');

      // Update profile table
      final supabaseClient = Supabase.instance.client;
      await supabaseClient.from('profile').update({
        'fcm_token': fcmToken,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId);

      debugPrint('✅ FCM token saved for user: $userId');

      // Optional: Verify the update (remove if causing issues)
      try {
        final verify = await supabaseClient
            .from('profile')
            .select('fcm_token')
            .eq('user_id', userId)
            .single();

        final storedToken = verify['fcm_token'] as String?;
        if (storedToken == fcmToken) {
          debugPrint('✅ FCM token verified in database');
        }
      } catch (e) {
        debugPrint('⚠️ Could not verify FCM token: $e');
      }
    } else {
      debugPrint('❌ FCM token is null or empty');
    }
  } catch (e, st) {
    debugPrint('❌ Error updating FCM token: $e');
    debugPrint('Stack trace: $st');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    // Main user stream
    userStream = product7SupabaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
        debugPrint('👤 User stream updated: ${user.uid}');
      });

    jwtTokenStream.listen((_) {});

    // Stop splash screen after delay
    Future.delayed(
      const Duration(milliseconds: 1500),
      () => _appStateNotifier.stopShowingSplashImage(),
    );

    // Handle app lifecycle for FCM token updates
    _setupAppLifecycleListener();
  }

  void _setupAppLifecycleListener() {
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          debugPrint('🔄 App resumed');
          // Update FCM token when app comes to foreground
          final user = Supabase.instance.client.auth.currentUser;
          if (user != null) {
            await Future.delayed(const Duration(seconds: 1));
            await _updateFcmTokenWithRetry(user.id, maxRetries: 2);
          }
        },
      ),
    );
  }

  String getRoute([RouteMatch? routeMatch]) {
    final lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Product7',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

// App lifecycle handler
class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function()? resumeCallBack;
  final Future<void> Function()? suspendingCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack!();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        if (suspendingCallBack != null) {
          await suspendingCallBack!();
        }
        break;
    }
  }
}
