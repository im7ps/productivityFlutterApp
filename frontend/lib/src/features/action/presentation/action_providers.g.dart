// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$actionListHash() => r'8e2f7de0a9114cacf344dd070dce30e3fb52f222';

/// See also [actionList].
@ProviderFor(actionList)
final actionListProvider = AutoDisposeFutureProvider<List<Action>>.internal(
  actionList,
  name: r'actionListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$actionListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActionListRef = AutoDisposeFutureProviderRef<List<Action>>;
String _$actionCreateControllerHash() =>
    r'11558a77781979a6cdff32a8e645b36ec056fbfa';

/// See also [ActionCreateController].
@ProviderFor(ActionCreateController)
final actionCreateControllerProvider =
    AutoDisposeNotifierProvider<
      ActionCreateController,
      AsyncValue<void>
    >.internal(
      ActionCreateController.new,
      name: r'actionCreateControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$actionCreateControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActionCreateController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
