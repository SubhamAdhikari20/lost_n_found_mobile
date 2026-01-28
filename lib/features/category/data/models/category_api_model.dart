import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';

class CategoryApiModel {
  final String? id;
  final String name;
  final String? description;
  final String? status;

  CategoryApiModel({
    this.id,
    required this.name,
    this.description,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
    };
  }

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    return CategoryApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      status: json['status'] as String?,
    );
  }

  // to JSON List
  static List<Map<String, dynamic>> toJsonList(
    List<CategoryApiModel> categoryModels,
  ) {
    return categoryModels
        .map((categoryModel) => categoryModel.toJson())
        .toList();
  }

  // from JSON List
  static List<CategoryApiModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => CategoryApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: id,
      name: name,
      description: description,
      status: status,
    );
  }

  factory CategoryApiModel.fromEntity(CategoryEntity entity) {
    return CategoryApiModel(
      id: entity.categoryId,
      name: entity.name,
      description: entity.description,
      status: entity.status,
    );
  }

  static List<CategoryEntity> toEntityList(List<CategoryApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
