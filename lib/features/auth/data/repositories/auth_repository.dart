import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/auth/data/datasources/auth_datasource.dart';
import 'package:lost_n_found/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:lost_n_found/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:lost_n_found/features/auth/data/models/user_api_model.dart';
import 'package:lost_n_found/features/auth/data/models/user_hive_model.dart';
import 'package:lost_n_found/features/auth/domain/entities/user_entity.dart';
import 'package:lost_n_found/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authLocalDatasource = ref.read(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return AuthRepository(
    authLocalDatasource: authLocalDatasource,
    authRemoteDatasource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _authLocalDatasource;
  final IAuthRemoteDatasource _authRemoteDatasource;
  final INetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDatasource authLocalDatasource,
    required IAuthRemoteDatasource authRemoteDatasource,
    required INetworkInfo networkInfo,
  }) : _authLocalDatasource = authLocalDatasource,
       _authRemoteDatasource = authRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, UserEntity>> signUp(UserEntity userEntity) async {
    if (await _networkInfo.isConnected) {
      try {
        final userModel = UserApiModel.fromEntity(userEntity);

        final result = await _authRemoteDatasource.signUp(userModel);
        if (result == null) {
          return const Left(ApiFailure(message: "Failed to sign up user!"));
        }

        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to sign up user!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final userModel = UserHiveModel.fromEntity(userEntity);

        final checkEmailExist = await _authLocalDatasource.isEmailExists(
          userModel.email,
        );
        if (checkEmailExist) {
          return const Left(
            LocalDatabaseFailure(
              message: "Sign Up failed! Email already exists.",
            ),
          );
        }

        final result = await _authLocalDatasource.signUp(userModel);
        if (result == null) {
          return const Left(
            LocalDatabaseFailure(message: "Failed to sign up user!"),
          );
        }

        return Right(result.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String identifier,
    String password,
  ) async {
    try {
      final user = await _authLocalDatasource.login(identifier, password);
      if (user == null) {
        return const Left(
          LocalDatabaseFailure(message: "Failed to login user!"),
        );
      }

      return Right(user.toEntity());
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDatasource.logout();
        if (!result) {
          return const Left(ApiFailure(message: "Failed to logout user!"));
        }

        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to logout user!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _authLocalDatasource.logout();
        if (!result) {
          return const Left(
            LocalDatabaseFailure(message: "Failed to logout user!"),
          );
        }

        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _authRemoteDatasource.getCurrentUser(userId);
        if (user == null) {
          return const Left(ApiFailure(message: "Failed to get current user!"));
        }

        return Right(user.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data["message"] ?? "Failed to get current user!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final user = await _authLocalDatasource.getCurrentUser(userId);
        if (user == null) {
          return const Left(
            LocalDatabaseFailure(message: "Failed to get current user!"),
          );
        }

        return Right(user.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
