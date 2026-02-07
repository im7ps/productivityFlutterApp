// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityLogListHash() => r'be8213023915426b796c74813c9f60715896110e';

/// See also [activityLogList].
@ProviderFor(activityLogList)
final activityLogListProvider =
    AutoDisposeFutureProvider<List<ActivityLog>>.internal(
      activityLogList,
      name: r'activityLogListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activityLogListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActivityLogListRef = AutoDisposeFutureProviderRef<List<ActivityLog>>;
String _$activityCreateControllerHash() =>
    r'c492adf3b0969ece5e3e50cb3fc68d81bf5ac533';

/// See also [ActivityCreateController].
@ProviderFor(ActivityCreateController)
final activityCreateControllerProvider =
    AutoDisposeAsyncNotifierProvider<ActivityCreateController, void>.internal(
      ActivityCreateController.new,
      name: r'activityCreateControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activityCreateControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActivityCreateController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
