import 'package:lost_n_found/features/auth/domain/entities/user_entity.dart';
import 'package:lost_n_found/features/batch/data/models/batch_api_model.dart';

class UserApiModel {
  final String? id;
  final String email;
  final String username;
  final String fullName;
  final String? phoneNumber;
  final String? password;
  final String? batchId;
  final String? profilePictureUrl;
  final BatchApiModel? batchModel;

  UserApiModel({
    this.id,
    required this.email,
    required this.username,
    required this.fullName,
    this.phoneNumber,
    this.password,
    this.batchId,
    this.profilePictureUrl,
    this.batchModel,
  });

  // to JSON
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "username": username,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "password": password,
      "batchId": batchId,
      "profilePictureUrl": profilePictureUrl,
    };
  }

  // From JSON
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: json["_id"] as String,
      email: json["email"] as String,
      username: json["username"] as String,
      fullName: json["fullName"] as String,
      phoneNumber: json["phoneNumber"] as String?,
      batchId: json["batchId"] as String?,
      profilePictureUrl: json["profilePictureUrl"] as String?,
      batchModel: json["batch"] != null
          ? BatchApiModel.fromJson(json["batch"] as Map<String, dynamic>)
          : null,
    );
  }

  // to JSON List
  static List<Map<String, dynamic>> toJsonList(List<UserApiModel> userModels) {
    return userModels.map((userModel) => userModel.toJson()).toList();
  }

  // from JSON List
  static List<UserApiModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => UserApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // to Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: id,
      email: email,
      username: username,
      fullName: fullName,
      phoneNumber: phoneNumber,
      batchId: batchId,
      profilePictureUrl: profilePictureUrl,
      batchEntity: batchModel?.toEntity(),
    );
  }

  // from Entity
  factory UserApiModel.fromEntity(UserEntity userEntity) {
    return UserApiModel(
      id: userEntity.userId,
      email: userEntity.email,
      username: userEntity.username,
      fullName: userEntity.fullName,
      phoneNumber: userEntity.phoneNumber,
      batchId: userEntity.batchId,
      profilePictureUrl: userEntity.profilePictureUrl,
    );
  }

  // to Entity List
  static List<UserEntity> toEntityList(List<UserApiModel> userModels) {
    return userModels.map((userModel) => userModel.toEntity()).toList();
  }

  // from Entity List
  static List<UserApiModel> fromEntityList(List<UserEntity> userEntities) {
    return userEntities
        .map((userEntity) => UserApiModel.fromEntity(userEntity))
        .toList();
  }
}
