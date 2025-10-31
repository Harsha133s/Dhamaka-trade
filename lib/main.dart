/// TradeVerse AI - Main Entry Point
/// AI-powered trading journal with community features and real-time analytics.

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (skip on web)
  try {
    if (!kIsWeb) {
      await dotenv.load();
    }
  } catch (e) {
    debugPrint('Warning: Could not load .env file: $e');
  }

  // Initialize Supabase with environment variables or fallback to defaults
  final supabaseUrl = kIsWeb 
      ? 'https://mmgaksbgywdperozjllf.supabase.co'
      : (dotenv.env['SUPABASE_URL'] ?? 'https://mmgaksbgywdperozjllf.supabase.co');
  final supabaseKey = kIsWeb
      ? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1tZ2Frc2JneXdkcGVyb3pqbGxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NzAxNzgsImV4cCI6MjA3NzE0NjE3OH0.perpfLzqVUdbciXIYyGjluzqc8Ymu4bzuRYKO8Fht0U'
      : (dotenv.env['SUPABASE_ANON_KEY'] ?? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1tZ2Frc2JneXdkcGVyb3pqbGxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NzAxNzgsImV4cCI6MjA3NzE0NjE3OH0.perpfLzqVUdbciXIYyGjluzqc8Ymu4bzuRYKO8Fht0U');

  debugPrint('Initializing Supabase with URL: $supabaseUrl');
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  debugPrint('Supabase initialized successfully');

  runApp(const ProviderScope(child: TradeVerseApp()));
}

class TradeVerseApp extends ConsumerWidget {
  const TradeVerseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'TradeVerse AI',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
