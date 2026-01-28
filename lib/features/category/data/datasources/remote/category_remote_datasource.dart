import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/api/api_client.dart';
import 'package:lost_n_found/core/api/api_endpoints.dart';
import 'package:lost_n_found/features/category/data/datasources/category_datasource.dart';
import 'package:lost_n_found/features/category/data/models/category_api_model.dart';

final categoryRemoteDatasourceProvider = Provider<ICategoryRemoteDataSource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);
  return CategoryRemoteDatasource(apiClient: apiClient);
});

class CategoryRemoteDatasource implements ICategoryRemoteDataSource {
  final ApiClient _apiClient;

  CategoryRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<CategoryApiModel>> getAllCategories() async {
    final response = await _apiClient.get(ApiEndpoints.categories);
    final data = response.data["data"] as List;
    return CategoryApiModel.fromJsonList(data);
  }
}
