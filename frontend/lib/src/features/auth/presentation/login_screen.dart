import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_repository.dart';

// Un semplice provider per gestire lo stato del caricamento
final loginLoadingProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController(); // Added for signup
  final _passwordController = TextEditingController();
  
  bool _isLoginMode = true; // Toggle state

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    final authRepo = ref.read(authRepositoryProvider);
    ref.read(loginLoadingProvider.notifier).state = true;

    if (_isLoginMode) {
      final result = await authRepo.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );
      _handleResult(result);
    } else {
      final result = await authRepo.signUp(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      _handleResult(result); 
    }
  }

  void _handleResult(dynamic result) {
    // Note: Do not disable loading here immediately for Login mode, 
    // because we have a subsequent async call (getCurrentUser)
    
    if (!mounted) {
       ref.read(loginLoadingProvider.notifier).state = false;
       return;
    }

    result.fold(
      (failure) {
        ref.read(loginLoadingProvider.notifier).state = false;
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: ${failure.message}'), backgroundColor: Colors.red),
        );
      },
      (success) async {
        if (_isLoginMode) {
          // Success is Token. Now fetch user profile to check onboarding status.
          final authRepo = ref.read(authRepositoryProvider);
          final userResult = await authRepo.getCurrentUser();
          
          ref.read(loginLoadingProvider.notifier).state = false;
          if (!mounted) return;

          userResult.fold(
            (failure) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Errore profilo: ${failure.message}'), backgroundColor: Colors.red),
            ),
            (user) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login Successo!'), backgroundColor: Colors.green),
              );
              
              if (user.isOnboardingCompleted) {
                context.go('/');
              } else {
                context.go('/onboarding');
              }
            },
          );
        } else {
          // Signup mode (Success is UserPublic)
          ref.read(loginLoadingProvider.notifier).state = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registrazione Successo! Ora fai il login.'), backgroundColor: Colors.green),
          );
          // Switch back to login mode
          setState(() => _isLoginMode = true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginLoadingProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_isLoginMode ? 'Login' : 'Registrazione')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              if (!_isLoginMode) ...[
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onSubmit,
                  child: isLoading 
                    ? const CircularProgressIndicator() 
                    : Text(_isLoginMode ? 'ENTRA' : 'REGISTRATI'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: isLoading ? null : () {
                  setState(() {
                    _isLoginMode = !_isLoginMode;
                  });
                },
                child: Text(_isLoginMode 
                  ? 'Non hai un account? Registrati' 
                  : 'Hai già un account? Entra'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
