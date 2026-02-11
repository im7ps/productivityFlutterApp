// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredTasksHash() => r'3734715830b5225283520bb47e50c1866993db58';

/// See also [filteredTasks].
@ProviderFor(filteredTasks)
final filteredTasksProvider = AutoDisposeProvider<List<TaskUIModel>>.internal(
  filteredTasks,
  name: r'filteredTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredTasksRef = AutoDisposeProviderRef<List<TaskUIModel>>;
String _$rankHash() => r'973fd441ce48b070ed16b734f49196d15fe6d0b5';

/// See also [rank].
@ProviderFor(rank)
final rankProvider = AutoDisposeProvider<double>.internal(
  rank,
  name: r'rankProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rankHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RankRef = AutoDisposeProviderRef<double>;
String _$rankLabelHash() => r'50fcd6d29f4805e7c1d30669068be247030dd86e';

/// See also [rankLabel].
@ProviderFor(rankLabel)
final rankLabelProvider = AutoDisposeProvider<String>.internal(
  rankLabel,
  name: r'rankLabelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rankLabelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RankLabelRef = AutoDisposeProviderRef<String>;
String _$taskSortHash() => r'4e01250e293f838561fba6a472b51e2e2993b60c';

/// See also [TaskSort].
@ProviderFor(TaskSort)
final taskSortProvider =
    AutoDisposeNotifierProvider<TaskSort, TaskSortOrder>.internal(
      TaskSort.new,
      name: r'taskSortProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$taskSortHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TaskSort = AutoDisposeNotifier<TaskSortOrder>;
String _$taskListHash() => r'47ab2e69d03aa5d4ea105a2d6d2784a6392c9074';

/// See also [TaskList].
@ProviderFor(TaskList)
final taskListProvider =
    AutoDisposeAsyncNotifierProvider<TaskList, List<TaskUIModel>>.internal(
      TaskList.new,
      name: r'taskListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$taskListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TaskList = AutoDisposeAsyncNotifier<List<TaskUIModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
