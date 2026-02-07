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
    // Trigger button fade-in after text reading time
    _startAnimation();
  }

  void _startAnimation() {
    setState(() => _showButton = false);
    Future.delayed(const Duration(milliseconds: 1500), () {
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
        _startAnimation(); // Reset animation for next slide
      });
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
    // Router redirect should handle the rest, but we can explicit go to home just in case
    if (mounted) context.go('/');
  }

  Color _getBackgroundColor(int page) {
    switch (page) {
      case 0:
        return const Color(0xFF1E1E2C); // Dark, noisy
      case 1:
        return const Color(0xFF2D2D44); // Slightly warmer/lighter
      case 2:
        return const Color(0xFF3E3E55); // More clarity
      case 3:
        return const Color(0xFF4B4B65); // Balanced
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  physics: const NeverScrollableScrollPhysics(), // Disable swipe
                  children: [
                    _buildPage(
                      text: "C'è troppo rumore...",
                      child: const Icon(Icons.volume_off_outlined,
                          size: 48, color: Colors.white54),
                    ),
                    _buildPage(
                      text: "La felicità non è una checklist...",
                      child: const Icon(Icons.checklist_rtl_rounded,
                          size: 48, color: Colors.white54),
                    ),
                    _buildPage(
                      text: "Ogni giorno è il Giorno 1...",
                      child: _buildEnergyBarPreview(),
                    ),
                    _buildPage(
                      text: "What I've Done.\nBenvenuto nel tuo equilibrio.",
                      isFinal: true,
                    ),
                  ],
                ),
              ),
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(
      {required String text, Widget? child, bool isFinal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (child != null) ...[
            child,
            const SizedBox(height: 40),
          ],
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1200),
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
              style: TextStyle(
                fontSize: isFinal ? 28 : 24,
                fontWeight: isFinal ? FontWeight.bold : FontWeight.w300,
                color: Colors.white,
                height: 1.5,
                fontFamily: 'Roboto', // Default, assumes available
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyBarPreview() {
    return Container(
      width: 200,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 0.3, // Static preview
        child: Container(
          decoration: BoxDecoration(
            color: Colors.tealAccent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    String label;
    VoidCallback? onPressed;

    switch (_currentPage) {
      case 0:
        label = "Respiro profondo";
        onPressed = () {
          HapticFeedback.heavyImpact();
          _nextPage();
        };
        break;
      case 1:
        label = "Capisco";
        onPressed = _nextPage;
        break;
      case 2:
        label = "Sono pronto";
        onPressed = _nextPage;
        break;
      case 3:
        label = "Inizia la Giornata";
        onPressed = _finishOnboarding;
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
          onPressed: _showButton ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18, letterSpacing: 1.2),
          ),
          child: Text(label.toUpperCase()),
        ),
      ),
    );
  }
}
