// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboardTitle => 'CURRENT RANK';

  @override
  String get arsenalTitle => 'YOUR TODAY\'S ARSENAL';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get appearanceSection => 'APPEARANCE';

  @override
  String get themeOption => 'Theme';

  @override
  String get languageOption => 'Language';

  @override
  String get chooseTheme => 'Choose Theme';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get portfolioTitle => 'PORTFOLIO';

  @override
  String get missionBriefingTitle => 'MISSION BRIEFING';

  @override
  String get tacticalPriorities =>
      'The 5 tactical priorities detected for you.';

  @override
  String addedToArsenal(String title) {
    return 'Mission \'$title\' added to the arsenal!';
  }

  @override
  String get infoSection => 'INFO';

  @override
  String get rewatchOnboarding => 'Re-watch Onboarding';

  @override
  String get onboardingSubtitle => 'Learn how the app works';

  @override
  String get onboardingTitle1 => 'There is too much noise.';

  @override
  String get onboardingBody1 =>
      'Between notifications, deadlines, and the apparently perfect lives of others, it\'s easy to feel lost.\n\nWe\'ve been taught to fill our days, but not to live them. We\'ve been told to accumulate achievements, but we often feel empty.';

  @override
  String get onboardingTitle2 => 'Happiness is not a checklist.';

  @override
  String get onboardingBody2 =>
      'It\'s not about finishing all the tasks. It\'s not about having more followers.\n\nHappiness is Connection (with those you truly love). It\'s Presence (being here, now, not in the screen). It\'s Autonomy (choosing what makes you feel good).';

  @override
  String get onboardingTitle3 => 'Every day is Day 1.';

  @override
  String get onboardingBody3 =>
      'Here there are no chains to maintain or scores that go down if you stop. The past is archived. The future doesn\'t exist yet.\n\nYou only have today to fill your Energy, Clarity, Tribe, and Soul bars. What you do today only counts for today. And that\'s okay.';

  @override
  String get onboardingTitle4 => 'What I\'ve Done.';

  @override
  String get onboardingBody4 =>
      'This app is not meant to make you more productive. It serves to make you more yourself.\n\nChoose your battles. Ignore the rest.\n\nWelcome to your balance.';

  @override
  String get onboardingStep0 => 'Deep Breath';

  @override
  String get onboardingStep1 => 'I understand';

  @override
  String get onboardingStep2 => 'I\'m ready';

  @override
  String get onboardingStep3 => 'Start the Day';
}
