import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

class BatchApiModel {
  final String? id;
  final String batchName;
  final String? status;

  BatchApiModel({this.id, required this.batchName, this.status});

  // to JSON
  Map<String, dynamic> toJson() {
    return {"batchName": batchName};
  }

  // from JSON
  factory BatchApiModel.fromJson(Map<String, dynamic> json) {
    return BatchApiModel(
      id: json["_id"] as String,
      batchName: json["batchName"] as String,
      status: json["status"] as String,
    );
  }

  // to JSON List
  static List<Map<String, dynamic>> toJsonList(
    List<BatchApiModel> batchModels,
  ) {
    return batchModels.map((batchModel) => batchModel.toJson()).toList();
  }

  // from JSON List
  static List<BatchApiModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => BatchApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // to Entity
  BatchEntity toEntity() {
    return BatchEntity(batchId: id, batchName: batchName, status: status);
  }

  // from Entity
  factory BatchApiModel.fromEntity(BatchEntity batchEntity) {
    return BatchApiModel(batchName: batchEntity.batchName);
  }

  // to Entity List
  static List<BatchEntity> toEntityList(List<BatchApiModel> batchModels) {
    return batchModels.map((batchModel) => batchModel.toEntity()).toList();
  }

  // from Entity List
  static List<BatchApiModel> fromEntityList(List<BatchEntity> batchEntities) {
    return batchEntities
        .map((batchEntity) => BatchApiModel.fromEntity(batchEntity))
        .toList();
  }
}
