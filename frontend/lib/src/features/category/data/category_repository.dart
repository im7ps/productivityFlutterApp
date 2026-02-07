import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/failure.dart';
import '../../../core/networking/dio_provider.dart';
import '../domain/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'category_repository.g.dart';

@riverpod
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepository(dio: ref.watch(dioProvider));
}

class CategoryRepository {
  final Dio _dio;

  CategoryRepository({required Dio dio}) : _dio = dio;

  TaskEither<Failure, List<Category>> fetchAllCategories() {
    return TaskEither.tryCatch(
      () async {
        final response = await _dio.get('/api/v1/categories');
        return (response.data as List)
            .map((e) => Category.fromJson(e))
            .toList();
      },
            (error, stackTrace) {
              // Mappa l'errore Dio in un Failure di dominio
              if (error is DioException) {
                 return Failure.network(error.message ?? 'Network Error');
              }
              return Failure.unknown(error.toString());
            },    );
  }
}
