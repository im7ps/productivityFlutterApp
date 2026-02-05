import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/failure.dart';
import '../../../core/networking/dio_provider.dart';
import '../../../core/networking/api_request.dart';
import 'models/category.dart';
import '../domain/category_repository.dart';

part 'category_repository_impl.g.dart';

@riverpod
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepositoryImpl(ref.watch(dioProvider));
}

class CategoryRepositoryImpl implements CategoryRepository {
  final Dio _dio;

  CategoryRepositoryImpl(this._dio);

  @override
  Future<Either<Failure, List<CategoryRead>>> getCategories() {
    return makeRequest(
      () => _dio.get('/api/v1/categories'),
      (data) {
        final List<dynamic> list = data;
        return list.map((e) => CategoryRead.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, CategoryRead>> createCategory(CategoryCreate category) {
    return makeRequest(
      () => _dio.post(
        '/api/v1/categories',
        data: category.toJson(),
      ),
      (data) => CategoryRead.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, CategoryRead>> updateCategory({
    required String id,
    required CategoryUpdate category,
  }) {
    return makeRequest(
      () => _dio.put(
        '/api/v1/categories/$id',
        data: category.toJson(),
      ),
      (data) => CategoryRead.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) {
    return makeRequest(
      () => _dio.delete('/api/v1/categories/$id'),
      (_) => null,
    );
  }
}
