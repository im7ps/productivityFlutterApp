import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/dimension_repository.dart';
import '../domain/dimension.dart';

part 'dimension_providers.g.dart';

@riverpod
Future<List<Dimension>> dimensionsList(DimensionsListRef ref) async {
  final repo = ref.watch(dimensionRepositoryProvider);
  return repo.getDimensions();
}
