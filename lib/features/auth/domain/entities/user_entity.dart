import 'package:equatable/equatable.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String email;
  final String username;
  final String fullName;
  final String? phoneNumber;
  final String? batchId;
  final String? password;
  final BatchEntity? batchEntity;
  final String? profilePictureUrl;

  const UserEntity({
    this.userId,
    required this.email,
    required this.username,
    required this.fullName,
    this.phoneNumber,
    this.batchId,
    this.password,
    this.batchEntity,
    this.profilePictureUrl,
  });

  @override
  List<Object?> get props => [
    userId,
    email,
    username,
    fullName,
    phoneNumber,
    batchId,
    password,
    batchEntity,
    profilePictureUrl,
  ];
}
