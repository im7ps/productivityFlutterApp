import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/router_provider.dart';
import 'core/theme/app_theme.dart';

class WhatIveDoneApp extends ConsumerWidget {
  const WhatIveDoneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: "What I've Done",
      theme: AppTheme.darkTheme, // Usiamo il tema scuro cinematografico
      routerConfig: router,
    );
  }
}
