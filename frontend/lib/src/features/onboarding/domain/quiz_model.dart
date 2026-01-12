class QuizAnswer {
  final String text;
  final Map<String, int> statModifiers; // Es: {'stat_strength': 2}

  const QuizAnswer({required this.text, required this.statModifiers});
}

class QuizQuestion {
  final String text;
  final List<QuizAnswer> answers;

  const QuizQuestion({required this.text, required this.answers});
}

// Mock Data: Domande sullo stile di vita
const List<QuizQuestion> onboardingQuestions = [
  QuizQuestion(
    text: "Qual è il tuo passatempo preferito?",
    answers: [
      QuizAnswer(
        text: "Fare sport o allenarmi all'aperto",
        statModifiers: {'stat_strength': 3, 'stat_endurance': 2},
      ),
      QuizAnswer(
        text: "Leggere un libro o imparare cose nuove",
        statModifiers: {'stat_intelligence': 3, 'stat_focus': 2},
      ),
      QuizAnswer(
        text: "Medito o pianifico la mia giornata",
        statModifiers: {'stat_focus': 4, 'stat_intelligence': 1},
      ),
    ],
  ),
  QuizQuestion(
    text: "Come affronti un problema difficile?",
    answers: [
      QuizAnswer(
        text: "Ci sbatto la testa finché non lo risolvo (Forza bruta)",
        statModifiers: {'stat_strength': 2, 'stat_endurance': 3},
      ),
      QuizAnswer(
        text: "Analizzo tutte le variabili prima di agire",
        statModifiers: {'stat_intelligence': 4, 'stat_focus': 1},
      ),
    ],
  ),
  QuizQuestion(
    text: "Cosa ti fa sentire più realizzato a fine giornata?",
    answers: [
      QuizAnswer(
        text: "La stanchezza fisica di un buon lavoro",
        statModifiers: {'stat_strength': 2, 'stat_endurance': 3},
      ),
      QuizAnswer(
        text: "Aver capito qualcosa che prima ignoravo",
        statModifiers: {'stat_intelligence': 3},
      ),
    ],
  ),
];
