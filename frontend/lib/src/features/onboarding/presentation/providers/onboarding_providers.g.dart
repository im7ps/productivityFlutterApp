// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizManifestHash() => r'e9046629e09de89514832b4dc058e5ee1358b200';

/// See also [quizManifest].
@ProviderFor(quizManifest)
final quizManifestProvider = AutoDisposeFutureProvider<QuizManifest>.internal(
  quizManifest,
  name: r'quizManifestProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizManifestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuizManifestRef = AutoDisposeFutureProviderRef<QuizManifest>;
String _$onboardingAnswersHash() => r'6ba7c955f821195888afcfd58f90e4a3a86ca935';

/// See also [OnboardingAnswers].
@ProviderFor(OnboardingAnswers)
final onboardingAnswersProvider =
    AutoDisposeNotifierProvider<OnboardingAnswers, Map<String, int>>.internal(
      OnboardingAnswers.new,
      name: r'onboardingAnswersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onboardingAnswersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OnboardingAnswers = AutoDisposeNotifier<Map<String, int>>;
String _$onboardingSubmitControllerHash() =>
    r'd2429ac584d74f18fea78cb9e33786dfcff2d5d5';

/// See also [OnboardingSubmitController].
@ProviderFor(OnboardingSubmitController)
final onboardingSubmitControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      OnboardingSubmitController,
      OnboardingResult?
    >.internal(
      OnboardingSubmitController.new,
      name: r'onboardingSubmitControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onboardingSubmitControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OnboardingSubmitController =
    AutoDisposeAsyncNotifier<OnboardingResult?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
