import 'package:dartz/dartz.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/domain/entities/user_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, UserEntity>> signUp(UserEntity userEntity);
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> getCurrentUser(String userId);
  Future<Either<Failure, bool>> logout();
}
