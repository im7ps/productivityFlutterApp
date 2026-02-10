import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dimension_repository.dart';
import '../domain/dimension.dart';

part 'dimension_providers.g.dart';

@riverpod
Future<List<Dimension>> dimensionsList(Ref ref) async {
  final repo = ref.watch(dimensionRepositoryProvider);
  return repo.getDimensions();
}
