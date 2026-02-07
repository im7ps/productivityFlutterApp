import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/auth_state_provider.dart';

part 'router_notifier.g.dart';

@riverpod
class RouterNotifier extends _$RouterNotifier implements Listenable {
  VoidCallback? _routerListener;
  bool _isLoggedIn = false;

  @override
  void build() {
    // Ascolta i cambiamenti dell'auth state
    final authState = ref.watch(authStateProvider);
    
    // Calcola il nuovo stato
    final newLoginState = authState.valueOrNull ?? false;

    // Se lo stato è cambiato, notifica il router
    if (_isLoggedIn != newLoginState) {
      _isLoggedIn = newLoginState;
      _routerListener?.call();
    }
  }

  bool get isLoggedIn => _isLoggedIn;

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerListener = null;
  }
}
