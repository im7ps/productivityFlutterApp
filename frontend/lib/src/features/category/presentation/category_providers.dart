import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/category.dart';
import '../data/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'category_providers.g.dart';

@riverpod
Future<List<Category>> categoriesList(Ref ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  final result = await repository.fetchAllCategories().run();

  return result.fold(
    (failure) => throw Exception(failure.displayMessage),
    (categories) => categories,
  );
}
