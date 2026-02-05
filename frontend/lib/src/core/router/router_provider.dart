import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/onboarding/presentation/screens/quiz_screen.dart';
import '../../features/daily_log/presentation/screens/daily_log_list_screen.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const QuizScreen(),
      ),
      GoRoute(
        path: '/daily-logs',
        builder: (context, state) => const DailyLogListScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Home')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Home Screen (Work in Progress)'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.go('/daily-logs'),
                  child: const Text('Vai ai Daily Logs'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Vai al Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
