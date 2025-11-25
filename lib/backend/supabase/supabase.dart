import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

export 'database/database.dart';

class SupaFlow {
  static const String _supabaseUrl = 'https://yifwqsbdmkljzglsyynq.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpZndxc2JkbWtsanpnbHN5eW5xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEwOTYyODIsImV4cCI6MjA1NjY3MjI4Mn0.5LnWlQSxiGD3dj-ltmlql-T97wEIOYGesM0Z_BD2Fbw';

  static bool _isInitialized = false;
  static bool _isInitializing = false;

  static Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;
    
    _isInitializing = true;
    try {
      await Supabase.initialize(
        url: _supabaseUrl,
        anonKey: _supabaseAnonKey,
        debug: true, // Set to true to see initialization logs
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );
      _isInitialized = true;
      print('✅ Supabase initialized successfully');
    } catch (e) {
      _isInitializing = false;
      print('❌ Supabase initialization failed: $e');
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  static SupabaseClient get client {
    if (!_isInitialized) {
      // Instead of throwing, try to initialize synchronously
      print('⚠️ Supabase not initialized, accessing instance directly');
      return Supabase.instance.client;
    }
    return Supabase.instance.client;
  }
}