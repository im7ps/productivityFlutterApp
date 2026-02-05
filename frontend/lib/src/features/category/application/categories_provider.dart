import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/category.dart';
import '../data/category_repository_impl.dart';

part 'categories_provider.g.dart';

@riverpod
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  Future<List<CategoryRead>> build() async {
    final repository = ref.watch(categoryRepositoryProvider);
    final result = await repository.getCategories();
    
    return result.fold(
      (failure) => throw failure,
      (categories) => categories,
    );
  }

  Future<void> addCategory(CategoryCreate category) async {
    final previousState = state;
    state = const AsyncLoading();
    if (previousState.hasValue) {
      state = AsyncLoading<List<CategoryRead>>().copyWithPrevious(previousState);
    }

    final repository = ref.read(categoryRepositoryProvider);
    final result = await repository.createCategory(category);

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        if (previousState.hasValue) {
           state = AsyncError<List<CategoryRead>>(failure, StackTrace.current).copyWithPrevious(previousState);
        }
      },
      (newCategory) {
        final currentList = previousState.valueOrNull ?? [];
        state = AsyncData([...currentList, newCategory]);
      },
    );
  }
  
  Future<void> updateCategory({required String id, required CategoryUpdate update}) async {
    final previousState = state;
    state = const AsyncLoading();
     if (previousState.hasValue) {
      state = AsyncLoading<List<CategoryRead>>().copyWithPrevious(previousState);
    }

    final repository = ref.read(categoryRepositoryProvider);
    final result = await repository.updateCategory(id: id, category: update);

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        if (previousState.hasValue) {
           state = AsyncError<List<CategoryRead>>(failure, StackTrace.current).copyWithPrevious(previousState);
        }
      },
      (updated) {
        final currentList = previousState.valueOrNull ?? [];
        state = AsyncData(currentList.map((c) => c.id == id ? updated : c).toList());
      },
    );
  }

  Future<void> deleteCategory(String id) async {
    final previousState = state;
    state = const AsyncLoading();
    if (previousState.hasValue) {
      state = AsyncLoading<List<CategoryRead>>().copyWithPrevious(previousState);
    }

    final repository = ref.read(categoryRepositoryProvider);
    final result = await repository.deleteCategory(id);

    result.fold(
      (failure) {
         state = AsyncError(failure, StackTrace.current);
         if (previousState.hasValue) {
           state = AsyncError<List<CategoryRead>>(failure, StackTrace.current).copyWithPrevious(previousState);
        }
      },
      (_) {
        final currentList = previousState.valueOrNull ?? [];
        state = AsyncData(currentList.where((c) => c.id != id).toList());
      },
    );
  }
}
