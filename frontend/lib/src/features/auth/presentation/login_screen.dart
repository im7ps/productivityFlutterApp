import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoginMode = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final controller = ref.read(authControllerProvider.notifier);
    
    // Clear previous errors if any? 
    // Riverpod AsyncNotifier handles state replacements.

    if (_isLoginMode) {
      final user = await controller.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );
      
      if (user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successo!'), backgroundColor: Colors.green),
        );
        if (user.isOnboardingCompleted) {
          context.go('/');
        } else {
          context.go('/onboarding');
        }
      }
    } else {
      final success = await controller.signUp(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrazione Successo! Ora fai il login.'), backgroundColor: Colors.green),
        );
        setState(() => _isLoginMode = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    // Listen for errors to show SnackBars
    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: ${next.error}'), backgroundColor: Colors.red),
        );
      }
    });

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
                onPressed: isLoading
                    ? null
                    : () {
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

