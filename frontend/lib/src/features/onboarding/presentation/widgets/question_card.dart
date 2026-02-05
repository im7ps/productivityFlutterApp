import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/quiz_model.dart';
import '../providers/onboarding_providers.dart';

class QuestionCard extends ConsumerWidget {
  final QuizQuestion question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answers = ref.watch(onboardingAnswersProvider);
    final selectedValue = answers[question.id];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.text, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...question.options.map((option) {
              return RadioListTile<int>(
                title: Text(option.label),
                subtitle: option.description != null
                    ? Text(option.description!)
                    : null,
                value: option.value,
                groupValue: selectedValue,
                onChanged: (val) {
                  if (val != null) {
                    ref
                        .read(onboardingAnswersProvider.notifier)
                        .selectAnswer(question.id, val);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
