import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    setState(() => _showButton = false);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _showButton = true);
    });
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutQuad,
      );
      setState(() {
        _currentPage++;
        _startAnimation();
      });
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
    if (mounted) context.go('/');
  }

  Color _getBackgroundColor(int page) {
    switch (page) {
      case 0:
        return const Color(0xFF121212); // Oscurità
      case 1:
        return const Color(0xFF1A1A2E); // Notte profonda
      case 2:
        return const Color(0xFF16213E); // Verso l'alba
      case 3:
        return const Color(0xFF0F3460); // Chiarezza
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        color: _getBackgroundColor(_currentPage),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildPage(
                      context,
                      text: "C'è troppo rumore",
                      icon: Icons.blur_on,
                    ),
                    _buildPage(
                      context,
                      text: "La felicità non è una checklist",
                      icon: Icons.filter_vintage_outlined,
                    ),
                    _buildPage(
                      context,
                      text: "Ogni giorno è il Giorno 1",
                      icon: Icons.wb_sunny_outlined,
                    ),
                    _buildPage(
                      context,
                      text: "What I've Done.\nBenvenuto nel tuo equilibrio",
                      isFinal: true,
                    ),
                  ],
                ),
              ),
              _buildBottomButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(
    BuildContext context, {
    required String text,
    IconData? icon,
    bool isFinal = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 80, color: Colors.white12),
            const SizedBox(height: 40),
          ],
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1500),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Text(
              text,
              textAlign: TextAlign.center,
              style:
                  (isFinal
                          ? theme.textTheme.displayLarge
                          : theme.textTheme.displayMedium)
                      ?.copyWith(
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            color: Colors.black45,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(ThemeData theme) {
    String label;
    VoidCallback? action;

    switch (_currentPage) {
      case 0:
        label = "Respiro profondo";
        action = () {
          HapticFeedback.heavyImpact();
          _nextPage();
        };
        break;
      case 1:
        label = "Capisco";
        action = _nextPage;
        break;
      case 2:
        label = "Sono pronto";
        action = _nextPage;
        break;
      case 3:
        label = "Inizia la Giornata";
        action = _finishOnboarding;
        break;
      default:
        label = "";
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: _showButton ? 1.0 : 0.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: TextButton(
          onPressed: _showButton ? action : null,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.white30, width: 1),
            ),
          ),
          child: Text(
            label.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
