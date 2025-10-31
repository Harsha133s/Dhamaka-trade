/// Navigation Router Configuration
/// Go Router with all routes for the app

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/app_scaffold.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/journal/screens/journal_screen.dart';
import '../../features/analytics/screens/analytics_screen.dart';
import '../../features/today/screens/today_screen.dart';
import '../../features/community/screens/community_screen.dart';
import '../../features/discover/screens/discover_screen.dart';
import '../../features/challenges/screens/challenges_screen.dart';
import '../../features/inbox/screens/inbox_screen.dart';
import '../../features/calendar/screens/calendar_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../services/auth_service.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);
  
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authService.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
      
      // If not authenticated and not on login/signup, redirect to login
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }
      
      // If authenticated and on login/signup, redirect to dashboard
      if (isAuthenticated && isLoggingIn) {
        return '/';
      }
      
      return null; // No redirect needed
    },
    routes: [
      // Auth routes (outside shell)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      
      // Authenticated routes (inside shell)
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'today',
            builder: (context, state) => const TodayScreen(),
          ),
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/journal',
            name: 'journal',
            builder: (context, state) => const JournalScreen(),
          ),
          GoRoute(
            path: '/analytics',
            name: 'analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/community',
            name: 'community',
            builder: (context, state) => const CommunityScreen(),
          ),
          GoRoute(
            path: '/discover',
            name: 'discover',
            builder: (context, state) => const DiscoverScreen(),
          ),
          GoRoute(
            path: '/challenges',
            name: 'challenges',
            builder: (context, state) => const ChallengesScreen(),
          ),
          GoRoute(
            path: '/inbox',
            name: 'inbox',
            builder: (context, state) => const InboxScreen(),
          ),
          GoRoute(
            path: '/calendar',
            name: 'calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/profile/:userId',
            name: 'profile',
            builder: (context, state) {
              final userId = state.pathParameters['userId'] ?? '';
              return ProfileScreen(userId: userId);
            },
          ),
        ],
      ),
    ],
  );
});
