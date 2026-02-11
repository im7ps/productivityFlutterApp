import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
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
  // Per l'animazione della barra nella Slide 3
  bool _showBarAnimation = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    setState(() {
      _showButton = false;
      _showBarAnimation = false;
    });
    
    // Tempo di lettura stimato prima di mostrare il bottone
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showButton = true);
    });

    // Attiva animazione specifica per la slide 3 (indice 2)
    if (_currentPage == 2) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _showBarAnimation = true);
      });
    }
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
      case 0: return const Color(0xFF121212); // The Problem: Oscurità/Rumore
      case 1: return const Color(0xFF3E2723); // The Truth: Toni Caldi (come richiesto)
      case 2: return const Color(0xFF1A237E); // The Method: Blu Elettrico/Energia
      case 3: return const Color(0xFF004D40); // The Promise: Verde/Equilibrio
      default: return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
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
                    // Slide 1
                    _buildPage(
                      context,
                      title: l10n.onboardingTitle1,
                      body: l10n.onboardingBody1,
                    ),
                    // Slide 2
                    _buildPage(
                      context,
                      title: l10n.onboardingTitle2,
                      body: l10n.onboardingBody2,
                    ),
                    // Slide 3
                    _buildPage(
                      context,
                      title: l10n.onboardingTitle3,
                      body: l10n.onboardingBody3,
                      child: _buildAnimatedBar(),
                    ),
                    // Slide 4
                    _buildPage(
                      context,
                      title: l10n.onboardingTitle4,
                      body: l10n.onboardingBody4,
                      isFinal: true,
                    ),
                  ],
                ),
              ),
              _buildBottomButton(theme, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, {
    required String title, 
    required String body, 
    Widget? child,
    bool isFinal = false
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Titolo
          Text(
            title,
            textAlign: TextAlign.center,
            style: (isFinal ? theme.textTheme.displayLarge : theme.textTheme.displayMedium)?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 32),
          
          // Custom Widget (es. Bar Animation)
          if (child != null) ...[
            child,
            const SizedBox(height: 32),
          ],

          // Corpo del testo
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
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
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
                height: 1.6,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBar() {
    return Container(
      width: 200,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            widthFactor: _showBarAnimation ? 0.75 : 0.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF64FFDA), Color(0xFF1E88E5)],
                ),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF64FFDA).withValues(alpha: 0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(ThemeData theme, AppLocalizations l10n) {
    String label;
    VoidCallback? action;

    switch (_currentPage) {
      case 0:
        label = l10n.onboardingStep0;
        action = () {
          HapticFeedback.heavyImpact();
          _nextPage();
        };
        break;
      case 1:
        label = l10n.onboardingStep1;
        action = _nextPage;
        break;
      case 2:
        label = l10n.onboardingStep2;
        action = _nextPage;
        break;
      case 3:
        label = l10n.onboardingStep3;
        action = _finishOnboarding;
        break;
      default:
        label = "";
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: _showButton ? 1.0 : 0.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
