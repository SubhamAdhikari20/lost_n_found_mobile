import 'package:dartz/dartz.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/category/data/datasources/category_datasource.dart';
import 'package:lost_n_found/features/category/data/models/category_hive_model.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/category/domain/repositories/category_repository.dart';

class CategoryRepository implements ICategoryRepository {
  final ICategoryDatasource _categoryDatasource;

  CategoryRepository({required ICategoryDatasource categoryDatasource})
    : _categoryDatasource = categoryDatasource;

  @override
  Future<Either<Failure, CategoryEntity>> createCategory(
    CategoryEntity categoryEntity,
  ) async {
    try {
      final categoryModel = CategoryHiveModel.fromEntity(categoryEntity);
      final result = await _categoryDatasource.createCategory(categoryModel);

      if (result != null) {
        return Right(result.toEntity());
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to create category"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCategory(String categoryId) async {
    try {
      final result = await _categoryDatasource.deleteCategory(categoryId);

      if (result) {
        return Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to delete category"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final categoryModels = await _categoryDatasource.getAllCategories();
      final categoryEntites = CategoryHiveModel.toEntityList(categoryModels);

      return Right(categoryEntites);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(
    String categoryId,
  ) async {
    try {
      final categoryModel = await _categoryDatasource.getCategoryById(
        categoryId,
      );

      if (categoryModel != null) {
        return Right(categoryModel.toEntity());
      }
      return Left(LocalDatabaseFailure(message: "Category not found"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> updateCategory(
    CategoryEntity categoryEntity,
  ) async {
    try {
      final categoryModel = CategoryHiveModel.fromEntity(categoryEntity);
      final result = await _categoryDatasource.updateCategory(categoryModel);

      if (result != null) {
        return Right(result.toEntity());
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to update category"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
