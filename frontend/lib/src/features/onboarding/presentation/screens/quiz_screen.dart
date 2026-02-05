import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/quiz_model.dart';
import '../providers/onboarding_providers.dart';
import '../widgets/question_card.dart';
import 'onboarding_result_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  static const routeName = 'onboarding-quiz';
  static const path = '/onboarding/quiz';

  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(int totalPages) {
    if (_currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  Future<void> _submit(BuildContext context) async {
    final success = await ref
        .read(onboardingSubmitControllerProvider.notifier)
        .submit();

    if (!context.mounted) return;

    if (success) {
      final result = ref.read(onboardingSubmitControllerProvider).value;
      if (result != null) {
        // Navigate to Result Screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OnboardingResultScreen(result: result),
          ),
        );
      }
    } else {
      // Error is handled in provider state, can show Snackbar here
      final state = ref.read(onboardingSubmitControllerProvider);
      if (state is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizManifestAsync = ref.watch(quizManifestProvider);
    final submitState = ref.watch(onboardingSubmitControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Character Setup')),
      body: quizManifestAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (manifest) {
          final categories = manifest.categories;
          final totalPages = categories.length;
          final isLastPage = _currentPage == totalPages - 1;

          return Column(
            children: [
              // Progress Indicator
              LinearProgressIndicator(
                value: (categories.isNotEmpty)
                    ? (_currentPage + 1) / categories.length
                    : 0,
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable swipe to enforce answering? Or allow? Let's disable for guided flow.
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategoryStep(category);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      ElevatedButton(
                        onPressed: submitState.isLoading ? null : _prevPage,
                        child: const Text('Back'),
                      )
                    else
                      const SizedBox.shrink(),

                    ElevatedButton(
                      onPressed: submitState.isLoading
                          ? null
                          : () {
                              if (isLastPage) {
                                _submit(context);
                              } else {
                                _nextPage(totalPages);
                              }
                            },
                      child: submitState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isLastPage ? 'Finish' : 'Next'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryStep(QuizCategory category) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(category.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          category.description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        ...category.questions.map((q) => QuestionCard(question: q)),
      ],
    );
  }
}
