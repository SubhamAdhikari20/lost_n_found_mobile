import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecase.dart';
import 'package:lost_n_found/features/batch/data/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

class UpdateBatchUsecasParams extends Equatable {
  final String batchId;
  final String batchName;
  final String? status;

  const UpdateBatchUsecasParams({
    required this.batchId,
    required this.batchName,
    this.status,
  });

  @override
  List<Object?> get props => [batchId, batchName, status];
}

final updateBatchUsecaseProvider = Provider<UpdateBatchUsecase>((ref) {
  final batchRepository = ref.read(batchRepositoryProvider);
  return UpdateBatchUsecase(batchRepository: batchRepository);
});

class UpdateBatchUsecase
    implements UsecaseWithParams<bool, UpdateBatchUsecasParams> {
  final IBatchRepository _batchRepository;

  UpdateBatchUsecase({required IBatchRepository batchRepository})
    : _batchRepository = batchRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateBatchUsecasParams params) async {
    BatchEntity batchEntity = BatchEntity(
      batchId: params.batchId,
      batchName: params.batchName,
      status: params.status,
    );
    return await _batchRepository.updateBatch(batchEntity);
  }
}
