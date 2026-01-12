import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/quiz_model.dart';
import '../domain/archetype.dart';
import '../domain/quiz_state.dart'; // Import QuizState
import '../../auth/presentation/auth_controller.dart';
import 'quiz_controller.dart'; // Import QuizController

class LifestyleQuizScreen extends ConsumerStatefulWidget {
  const LifestyleQuizScreen({super.key});

  @override
  ConsumerState<LifestyleQuizScreen> createState() => _LifestyleQuizScreenState();
}

class _LifestyleQuizScreenState extends ConsumerState<LifestyleQuizScreen> {
  // Stato locale per gestire la transizione alla schermata dei risultati
  Archetype? _calculatedArchetype;

  void _processResult(QuizState quizState) {
    final stats = quizState.accumulatedStats;
    final mentalScore = (stats['stat_intelligence'] ?? 0) + (stats['stat_focus'] ?? 0);
    final physicalScore = (stats['stat_strength'] ?? 0) + (stats['stat_endurance'] ?? 0);

    Archetype resultArchetype;
    if (mentalScore > physicalScore) {
      resultArchetype = availableArchetypes.firstWhere((a) => a.id == 'studioso');
    } else {
      resultArchetype = availableArchetypes.firstWhere((a) => a.id == 'sportivo');
    }

    setState(() {
      _calculatedArchetype = resultArchetype;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizStateAsync = ref.watch(quizControllerProvider);

    return quizStateAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Errore caricamento quiz: $err'))),
      data: (quizState) {
        // Se abbiamo finito o calcolato un archetipo, mostriamo la schermata dei risultati
        if (_calculatedArchetype != null || quizState.isFinished) {
          // Se siamo appena finiti ma non abbiamo ancora calcolato l'archetipo, facciamolo ora.
          // Nota: quizState.isFinished è true quando si risponde all'ultima.
          if (_calculatedArchetype == null && quizState.isFinished) {
             // Dobbiamo schedulare questo aggiornamento per evitare errori durante il build
             WidgetsBinding.instance.addPostFrameCallback((_) {
               _processResult(quizState);
             });
             // Nel frattempo mostriamo un loader o nulla
             return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (_calculatedArchetype != null) {
              return QuizResultScreen(
                archetype: _calculatedArchetype!,
                finalStats: quizState.accumulatedStats,
              );
          }
        }
        
        // --- QUIZ UI ---
        // Safety check: index out of bounds (se cambiamo numero domande nel codice ma abbiamo vecchio salvataggio)
        if (quizState.currentQuestionIndex >= onboardingQuestions.length) {
            // Reset forzato o mostra errore
             WidgetsBinding.instance.addPostFrameCallback((_) {
               ref.read(quizControllerProvider.notifier).clearProgress();
             });
             return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final question = onboardingQuestions[quizState.currentQuestionIndex];
        final progress = (quizState.currentQuestionIndex + 1) / onboardingQuestions.length;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 32),
                  Text(
                    'Domanda ${quizState.currentQuestionIndex + 1}/${onboardingQuestions.length}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question.text,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ...question.answers.map((answer) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {
                         ref.read(quizControllerProvider.notifier).answerQuestion(
                           answer, 
                           onboardingQuestions.length
                         );
                      },
                      child: Text(
                        answer.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class QuizResultScreen extends ConsumerStatefulWidget {
  final Archetype archetype;
  final Map<String, int> finalStats;

  const QuizResultScreen({
    super.key, 
    required this.archetype,
    required this.finalStats,
  });

  @override
  ConsumerState<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen> {
  
  @override
  Widget build(BuildContext context) {
    // Listen to the controller state to handle side effects (navigation, errors)
    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (previous, next) {
        next.whenOrNull(
          data: (_) {
            // Successo: Pulisci progressi locali e naviga alla home
            ref.read(quizControllerProvider.notifier).clearProgress();
            context.go('/'); 
          },
          error: (error, stack) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Errore: $error'), backgroundColor: Colors.red),
            );
          },
        );
      },
    );

    final state = ref.watch(authControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Il tuo profilo ideale è...',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 24),
              Icon(
                _getIconData(widget.archetype.iconName),
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                widget.archetype.title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.archetype.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              const Text("Le tue statistiche iniziali:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...widget.finalStats.entries.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(e.key.replaceAll('stat_', '').toUpperCase(), 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: e.value / 20.0,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(e.value.toString()),
                  ],
                ),
              )),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isLoading ? null : () {
                    // Trigger the action. Side effects are handled by the listener.
                    ref.read(authControllerProvider.notifier).completeOnboarding(widget.finalStats);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                        : const Text('INIZIA LA TUA AVVENTURA'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'fitness_center': return Icons.fitness_center;
      case 'school': return Icons.school;
      default: return Icons.help_outline;
    }
  }
}
