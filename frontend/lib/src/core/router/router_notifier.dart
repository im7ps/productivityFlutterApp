import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/auth_state_provider.dart';
import '../../features/onboarding/presentation/onboarding_controller.dart';

part 'router_notifier.g.dart';

@riverpod
class RouterNotifier extends _$RouterNotifier implements Listenable {
  VoidCallback? _routerListener;
  bool _isLoggedIn = false;
  bool _isOnboardingSeen = false;
  bool _isLoading = true;

  @override
  void build() {
    // Watch Auth State
    final authState = ref.watch(authStateProvider);
    // Watch Onboarding State
    final onboardingState = ref.watch(onboardingControllerProvider);
    
    final newLoginState = authState.valueOrNull ?? false;
    final newOnboardingState = onboardingState.valueOrNull ?? false;
    final newLoadingState = authState.isLoading || onboardingState.isLoading;

    if (_isLoggedIn != newLoginState || 
        _isOnboardingSeen != newOnboardingState || 
        _isLoading != newLoadingState) {
      
      _isLoggedIn = newLoginState;
      _isOnboardingSeen = newOnboardingState;
      _isLoading = newLoadingState;
      
      _routerListener?.call();
    }
  }

  bool get isLoggedIn => _isLoggedIn;
  bool get isOnboardingSeen => _isOnboardingSeen;
  bool get isLoading => _isLoading;

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerListener = null;
  }
}
