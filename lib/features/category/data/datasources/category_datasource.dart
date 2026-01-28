import 'package:lost_n_found/features/category/data/models/category_api_model.dart';
import 'package:lost_n_found/features/category/data/models/category_hive_model.dart';

abstract interface class ICategoryLocalDatasource {
  Future<List<CategoryHiveModel>> getAllCategories();
  Future<CategoryHiveModel?> getCategoryById(String categoryId);
  Future<CategoryHiveModel?> createCategory(CategoryHiveModel category);
  Future<CategoryHiveModel?> updateCategory(CategoryHiveModel category);
  Future<bool> deleteCategory(String categoryId);
}

abstract interface class ICategoryRemoteDataSource {
  Future<List<CategoryApiModel>> getAllCategories();
}
