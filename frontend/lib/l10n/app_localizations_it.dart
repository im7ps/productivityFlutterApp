// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get dashboardTitle => 'RANK ATTUALE';

  @override
  String get arsenalTitle => 'IL TUO ARSENALE DI OGGI';

  @override
  String get settingsTitle => 'IMPOSTAZIONI';

  @override
  String get appearanceSection => 'ASPETTO';

  @override
  String get themeOption => 'Tema';

  @override
  String get languageOption => 'Lingua';

  @override
  String get chooseTheme => 'Scegli il tema';

  @override
  String get chooseLanguage => 'Scegli la lingua';

  @override
  String get themeSystem => 'Predefinito di sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get portfolioTitle => 'PORTFOLIO';

  @override
  String get missionBriefingTitle => 'MISSION BRIEFING';

  @override
  String get tacticalPriorities => 'Le 5 priorità tattiche rilevate per te.';

  @override
  String addedToArsenal(String title) {
    return 'Missione \'$title\' aggiunta all\'arsenale!';
  }

  @override
  String get infoSection => 'INFO';

  @override
  String get rewatchOnboarding => 'Rivedi Onboarding';

  @override
  String get onboardingSubtitle => 'Scopri come funziona l\'app';

  @override
  String get onboardingTitle1 => 'C\'è troppo rumore.';

  @override
  String get onboardingBody1 =>
      'Tra notifiche, scadenze e vite apparentemente perfette degli altri, è facile sentirsi smarriti.\n\nCi hanno insegnato a riempire le giornate, ma non a viverle. Ci hanno detto di accumulare traguardi, ma ci sentiamo spesso vuoti.';

  @override
  String get onboardingTitle2 => 'La felicità non è una checklist.';

  @override
  String get onboardingBody2 =>
      'Non è finire tutte le task. Non è avere più follower.\n\nLa felicità è Connessione (con chi ami davvero). È Presenza (essere qui, ora, non nello schermo). È Autonomia (scegliere cosa ti fa stare bene).';

  @override
  String get onboardingTitle3 => 'Ogni giorno è il Giorno 1.';

  @override
  String get onboardingBody3 =>
      'Qui non ci sono catene da mantenere o punteggi che scendono se ti fermi. Il passato è archiviato. Il futuro non esiste ancora.\n\nHai solo oggi per riempire le tue barre di Energia, Chiarezza, Tribù e Anima. Quello che fai oggi, conta solo per oggi. E va bene così.';

  @override
  String get onboardingTitle4 => 'What I\'ve Done.';

  @override
  String get onboardingBody4 =>
      'Questa app non serve a renderti più produttivo. Serve a renderti più te stesso.\n\nScegli le tue battaglie. Ignora il resto.\n\nBenvenuto nel tuo equilibrio.';

  @override
  String get onboardingStep0 => 'Respiro profondo';

  @override
  String get onboardingStep1 => 'Capisco';

  @override
  String get onboardingStep2 => 'Sono pronto';

  @override
  String get onboardingStep3 => 'Inizia la Giornata';
}
