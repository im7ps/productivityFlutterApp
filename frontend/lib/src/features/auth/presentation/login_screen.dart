import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
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
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final controller = ref.read(authControllerProvider.notifier);

    if (_isLoginMode) {
      final user = await controller.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.loginSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      final success = await controller.signUp(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.signupSuccess),
            backgroundColor: Colors.green,
          ),
        );
        setState(() => _isLoginMode = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.errorGeneric}: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLoginMode ? AppStrings.loginTitle : AppStrings.signupTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.usernameLabel,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (!_isLoginMode) ...[
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.emailLabel,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: AppStrings.passwordLabel,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onSubmit,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          _isLoginMode
                              ? AppStrings.loginButton
                              : AppStrings.signupButton,
                        ),
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
                child: Text(
                  _isLoginMode
                      ? AppStrings.noAccountText
                      : AppStrings.hasAccountText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
