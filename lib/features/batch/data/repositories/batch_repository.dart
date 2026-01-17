import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_n_found/features/batch/data/datasources/local/batch_local_datasource.dart';
import 'package:lost_n_found/features/batch/data/datasources/remote/batch_remote_datasource.dart';
import 'package:lost_n_found/features/batch/data/models/batch_api_model.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

final batchRepositoryProvider = Provider<IBatchRepository>((ref) {
  final batchLocalDatasource = ref.read(batchLocalDatasourceProvider);
  final batchRemoteDatasource = ref.read(batchRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return BatchRepository(
    batchLocalDatasource: batchLocalDatasource,
    batchRemoteDatasource: batchRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class BatchRepository implements IBatchRepository {
  final IBatchLocalDatasource _batchLocalDatasource;
  final IBatchRemoteDatasource _batchRemoteDatasource;
  final INetworkInfo _networkInfo;

  BatchRepository({
    required IBatchLocalDatasource batchLocalDatasource,
    required IBatchRemoteDatasource batchRemoteDatasource,
    required INetworkInfo networkInfo,
  }) : _batchLocalDatasource = batchLocalDatasource,
       _batchRemoteDatasource = batchRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> createBatch(BatchEntity batch) async {
    try {
      final model = BatchHiveModel.fromEntity(batch);
      final result = await _batchLocalDatasource.createBatch(model);

      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to create batch"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBatch(String batchId) async {
    try {
      final result = await _batchLocalDatasource.deleteBatch(batchId);

      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to delete batch"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> getAllBatches() async {
    // Check for internet connection
    if (await _networkInfo.isConnected) {
      try {
        final batchModels = await _batchRemoteDatasource.getAllBatches();
        final batchEntities = BatchApiModel.toEntityList(batchModels);

        return Right(batchEntities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to fetch batches",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _batchLocalDatasource.getAllBatches();
        final entities = BatchHiveModel.toEntityList(models);

        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, BatchEntity>> getBatchById(String batchId) async {
    try {
      final model = await _batchLocalDatasource.getBatchById(batchId);
      if (model != null) {
        return Right(model.toEntity());
      }
      return Left(LocalDatabaseFailure(message: "Batch not found"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateBatch(BatchEntity batch) async {
    try {
      final model = BatchHiveModel.fromEntity(batch);
      final result = await _batchLocalDatasource.updateBatch(model);

      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to update batch"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
