import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/daily_log/presentation/screens/daily_log_list_screen.dart';
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
      // Usiamo lo stato interno del notifier che è sincronizzato con l'auth
      final isLoggedIn = notifier.isLoggedIn;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/daily-logs',
        builder: (context, state) => const DailyLogListScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
    ],
  );
}
