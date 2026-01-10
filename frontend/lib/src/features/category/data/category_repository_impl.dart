import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/failure.dart';
import '../../../core/networking/dio_provider.dart';
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
  Future<Either<Failure, List<CategoryRead>>> getCategories() async {
    try {
      final response = await _dio.get('/api/v1/categories');
      final List<dynamic> list = response.data;
      final categories = list.map((e) => CategoryRead.fromJson(e)).toList();
      return Right(categories);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryRead>> createCategory(CategoryCreate category) async {
    try {
      final response = await _dio.post(
        '/api/v1/categories',
        data: category.toJson(),
      );
      return Right(CategoryRead.fromJson(response.data));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryRead>> updateCategory({
    required String id,
    required CategoryUpdate category,
  }) async {
    try {
      final response = await _dio.put(
        '/api/v1/categories/$id',
        data: category.toJson(),
      );
      return Right(CategoryRead.fromJson(response.data));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await _dio.delete('/api/v1/categories/$id');
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _handleDioError(DioException e) {
    // This could be extracted to a shared mixin or helper
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('detail')) {
         final detail = data['detail'];
         if (detail is String) return ServerFailure(detail, e.response?.statusCode);
         return ServerFailure('Validation Error', e.response?.statusCode);
      }
      return ServerFailure('Server Error: ${e.response?.statusCode}', e.response?.statusCode);
    }
    return const NetworkFailure();
  }
}
