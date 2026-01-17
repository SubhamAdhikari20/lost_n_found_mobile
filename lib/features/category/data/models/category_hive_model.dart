import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:uuid/uuid.dart';

part "category_hive_model.g.dart";

@HiveType(typeId: HiveTableConstant.categoryTypeId)
class CategoryHiveModel extends HiveObject {
  @HiveField(0)
  final String? categoryId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? status;

  CategoryHiveModel({
    String? categoryId,
    required this.name,
    String? description,
    String? status,
  }) : categoryId = categoryId ?? Uuid().v4(),
       description = description ?? "",
       status = status ?? "active";

  // Convert Model to Category Entity
  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      name: name,
      description: description,
      status: status,
    );
  }

  // Convert Category Entity to Model
  factory CategoryHiveModel.fromEntity(CategoryEntity categoryEntity) {
    return CategoryHiveModel(
      categoryId: categoryEntity.categoryId,
      name: categoryEntity.name,
      description: categoryEntity.description,
      status: categoryEntity.status,
    );
  }

  // Convert List of Models to List of Category Entities
  static List<CategoryEntity> toEntityList(List<CategoryHiveModel> categoryModels) {
    return categoryModels.map((model) => model.toEntity()).toList();
  }
}
