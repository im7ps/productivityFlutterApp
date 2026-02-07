import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/daily_log/presentation/screens/daily_log_list_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import 'router_notifier.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  // Otteniamo l'istanza del Notifier che implementa Listenable.
  // IMPORTANTE: Questo richiede che il build_runner sia stato eseguito con successo.
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier, // Il router ascolta questo oggetto
    redirect: (context, state) {
      // Usiamo lo stato interno del notifier che è sincronizzato con l'auth e onboarding
      if (notifier.isLoading) return null; // Wait for state to be ready

      final isLoggedIn = notifier.isLoggedIn;
      final isOnboardingSeen = notifier.isOnboardingSeen;

      final isLoggingIn = state.matchedLocation == '/login';
      final isOnboarding = state.matchedLocation == '/onboarding';

      // 1. Check Onboarding First
      if (!isOnboardingSeen) {
        return isOnboarding ? null : '/onboarding';
      }

      // 2. Check Auth
      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      // 3. If logged in and onboarding seen, prevent access to login/onboarding pages
      if (isLoggingIn || isOnboarding) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen()),
      GoRoute(
        path: '/daily-logs',
        builder: (context, state) => const DailyLogListScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
    ],
  );
}
