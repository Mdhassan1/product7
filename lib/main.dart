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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FlutterFlow dev environment
  final environmentValues = FFDevEnvironmentValues();
  await environmentValues.initialize();

  // Init Firebase
try {
  await initFirebase();
} catch (e, st) {
  debugPrint('❌ Firebase init error: $e\n$st');
}
  // Init Supabase
try {
  await SupaFlow.initialize();
} catch (e, st) {
  debugPrint('❌ Supabase init error: $e\n$st');
}
  // Init Push Notifications

try {
  await PushNotifications.init();
} catch (e, st) {
  debugPrint('❌ PushNotifications init error: $e\n$st');
}
  // FlutterFlow theme
  await FlutterFlowTheme.initialize();

  // App State
  final appState = FFAppState();
  await appState.initializePersistedState();

  // --- CORRECTED FCM token logic ---
  final supabaseClient = Supabase.instance.client;

  // Listen to auth state changes
  supabaseClient.auth.onAuthStateChange.listen((event) async {
    debugPrint('🔄 Auth state changed: ${event.event}');
    
    final user = supabaseClient.auth.currentUser;
    if (user != null && event.event == AuthChangeEvent.signedIn) {
      debugPrint('👤 User signed in: ${user.id}');
      
      // Wait a bit for user to be fully initialized
      await Future.delayed(const Duration(seconds: 2));
      
      await _updateFcmToken(user.id);
    }
  });

  // Also check for existing user on app start
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final initialUser = supabaseClient.auth.currentUser;
    if (initialUser != null) {
      debugPrint('🔍 Found existing user: ${initialUser.id}');
      await Future.delayed(const Duration(seconds: 3));
      await _updateFcmToken(initialUser.id);
    }
  });

  runApp(
    ChangeNotifierProvider(
      create: (context) => appState,
      child: const MyApp(),
    ),
  );
}


void testFCM() async {
  try {
    print('🟡 Testing FCM directly...');
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    print('✅ FCM Token: $token');
  } catch (e) {
    print('❌ FCM Test Error: $e');
  }
}

// Call this in main() after Firebase.initializeApp()


// Helper function to update FCM token
Future<void> _updateFcmToken(String userId) async {
  try {
    final supabaseClient = Supabase.instance.client;
    
    // Get FCM token
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('🟢 FCM Token retrieved: $fcmToken');

    if (fcmToken != null && fcmToken.isNotEmpty) {
      // Update the profile table
      final response = await supabaseClient
          .from('profile')
          .update({'fcm_token': fcmToken})
          .eq('user_id', userId);

      debugPrint('✅ FCM token saved to profile table for user: $userId');
      
      // Verify the update
      final verify = await supabaseClient
          .from('profile')
          .select('fcm_token')
          .eq('user_id', userId)
          .single();
          
      debugPrint('🔍 Verified FCM token in DB: ${verify['fcm_token']}');
    } else {
      debugPrint('❌ FCM token is null or empty');
    }
  } catch (e, st) {
    debugPrint('❌ Error updating FCM token: $e\n$st');
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
      });

    jwtTokenStream.listen((_) {});
    Future.delayed(const Duration(milliseconds: 1000),
        () => _appStateNotifier.stopShowingSplashImage());
  }

  // Add getRoute / getRouteStack to avoid flutter_flow_util errors
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
