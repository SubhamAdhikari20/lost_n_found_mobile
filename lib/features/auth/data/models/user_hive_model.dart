import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/auth/domain/entities/user_entity.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:uuid/uuid.dart';

part "user_hive_model.g.dart";

@HiveType(typeId: HiveTableConstant.userTypeId)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String fullName;

  @HiveField(4)
  final String? phoneNumber;

  @HiveField(5)
  final String? password;

  @HiveField(6)
  final String? batchId;

  @HiveField(7)
  final String? profilePictureUrl;

  UserHiveModel({
    String? userId,
    required this.email,
    required this.username,
    required this.fullName,
    this.phoneNumber,
    this.password,
    this.batchId,
    this.profilePictureUrl,
  }) : userId = userId ?? Uuid().v4();

  // Convert Model to User Entity
  UserEntity toEntity({BatchEntity? batchEntity}) {
    return UserEntity(
      userId: userId,
      email: email,
      username: username,
      fullName: fullName,
      phoneNumber: phoneNumber,
      password: password,
      batchId: batchId,
      batchEntity: batchEntity,
      profilePictureUrl: profilePictureUrl,
    );
  }

  // Convert User Entity to Model
  factory UserHiveModel.fromEntity(UserEntity userEntity) {
    return UserHiveModel(
      userId: userEntity.userId,
      email: userEntity.email,
      username: userEntity.username,
      fullName: userEntity.fullName,
      phoneNumber: userEntity.phoneNumber,
      password: userEntity.password,
      batchId: userEntity.batchId,
      profilePictureUrl: userEntity.profilePictureUrl,
    );
  }

  // Convert List of Models to List of User Entities
  static List<UserEntity> toEntityList(List<UserHiveModel> userModels) {
    return userModels.map((userModel) => userModel.toEntity()).toList();
  }
}
