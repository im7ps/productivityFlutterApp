import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failure.dart';
import '../data/models/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryRead>>> getCategories();
  
  Future<Either<Failure, CategoryRead>> createCategory(CategoryCreate category);
  
  Future<Either<Failure, CategoryRead>> updateCategory({
    required String id,
    required CategoryUpdate category,
  });
  
  Future<Either<Failure, void>> deleteCategory(String id);
}
