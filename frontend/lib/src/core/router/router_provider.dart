import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/daily_log/presentation/screens/daily_log_list_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/consultant/presentation/consultant_screen.dart';
import 'router_notifier.dart';
import '../../features/action/presentation/portfolio_screen.dart';

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
      final loc = state.matchedLocation;
      print("DEBUG: Router redirect check for location: $loc");

      // Usiamo lo stato interno del notifier che è sincronizzato con l'auth e onboarding
      if (notifier.isLoading) {
        print("DEBUG: Router is waiting for loading...");
        return null;
      }

      final isLoggedIn = notifier.isLoggedIn;
      final isOnboardingSeen = notifier.isOnboardingSeen;

      print(
        "DEBUG: State -> LoggedIn: $isLoggedIn, OnboardingSeen: $isOnboardingSeen",
      );

      final isLoggingIn = loc == '/login';
      final isOnboarding = loc == '/onboarding';

      // 1. Check Onboarding First
      if (!isOnboardingSeen) {
        print("DEBUG: Onboarding not seen, redirecting to /onboarding");
        return isOnboarding ? null : '/onboarding';
      }

      // 2. Check Auth
      if (!isLoggedIn) {
        print("DEBUG: Not logged in, redirecting to /login");
        return isLoggingIn ? null : '/login';
      }

      // 3. Prevent access to login if everything is done,
      // but ALLOW /onboarding if requested manually (for re-watching)
      if (isLoggingIn) {
        print("DEBUG: Already logged in, redirecting to / (Dashboard)");
        return '/';
      }

      if (isOnboarding && isLoggedIn) {
        print("DEBUG: Manual onboarding access allowed");
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/daily-logs',
        builder: (context, state) => const DailyLogListScreen(),
      ),
      GoRoute(
        path: '/consultant',
        builder: (context, state) => const ConsultantScreen(),
      ),
      GoRoute(
        path: '/portfolio',
        builder: (context, state) => const PortfolioScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
    ],
  );
}
