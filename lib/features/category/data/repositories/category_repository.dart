import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/category/data/datasources/category_datasource.dart';
import 'package:lost_n_found/features/category/data/datasources/local/category_local_datasource.dart';
import 'package:lost_n_found/features/category/data/datasources/remote/category_remote_datasource.dart';
import 'package:lost_n_found/features/category/data/models/category_api_model.dart';
import 'package:lost_n_found/features/category/data/models/category_hive_model.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/category/domain/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) {
  final categoryLocalDatasource = ref.read(categoryLocalDatasourceProvider);
  final categoryRemoteDatasource = ref.read(categoryRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return CategoryRepository(
    categoryLocalDatasource: categoryLocalDatasource,
    categoryRemoteDatasource: categoryRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class CategoryRepository implements ICategoryRepository {
  final ICategoryLocalDatasource _categoryLocalDatasource;
  final ICategoryRemoteDataSource _categoryRemoteDatasource;
  final INetworkInfo _networkInfo;

  CategoryRepository({
    required ICategoryLocalDatasource categoryLocalDatasource,
    required ICategoryRemoteDataSource categoryRemoteDatasource,
    required INetworkInfo networkInfo,
  }) : _categoryLocalDatasource = categoryLocalDatasource,
       _categoryRemoteDatasource = categoryRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, CategoryEntity>> createCategory(
    CategoryEntity categoryEntity,
  ) async {
    try {
      final categoryModel = CategoryHiveModel.fromEntity(categoryEntity);
      final result = await _categoryLocalDatasource.createCategory(
        categoryModel,
      );

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
      final result = await _categoryLocalDatasource.deleteCategory(categoryId);

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
    if (await _networkInfo.isConnected) {
      try {
        final result = await _categoryRemoteDatasource.getAllCategories();
        if (result.isEmpty) {
          return Left(ApiFailure(message: "Failed! Categories are empty."));
        }

        final categoryEntites = CategoryApiModel.toEntityList(result);
        return Right(categoryEntites);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data["message"] ?? "Failed to fetch all categories",
          ),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    } else {
      try {
        final categoryModels = await _categoryLocalDatasource
            .getAllCategories();
        final categoryEntites = CategoryHiveModel.toEntityList(categoryModels);

        return Right(categoryEntites);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(
    String categoryId,
  ) async {
    try {
      final categoryModel = await _categoryLocalDatasource.getCategoryById(
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
      final result = await _categoryLocalDatasource.updateCategory(
        categoryModel,
      );

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
