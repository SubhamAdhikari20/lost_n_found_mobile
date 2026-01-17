import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecase.dart';
import 'package:lost_n_found/features/batch/data/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

class CreateBatchUsecaseParams extends Equatable {
  final String batchName;

  const CreateBatchUsecaseParams({required this.batchName});

  @override
  List<Object?> get props => [batchName];
}

// Provider for Create Batch Usecase
final createBatchUsecaseProvider = Provider<CreateBatchUsecase>((ref) {
  final batchRepository = ref.read(batchRepositoryProvider);
  return CreateBatchUsecase(batchRepository: batchRepository);
});

class CreateBatchUsecase
    implements UsecaseWithParams<bool, CreateBatchUsecaseParams> {
  final IBatchRepository _batchRepository;

  CreateBatchUsecase({required IBatchRepository batchRepository})
    : _batchRepository = batchRepository;

  @override
  Future<Either<Failure, bool>> call(CreateBatchUsecaseParams params) async {
    BatchEntity batchEntity = BatchEntity(batchName: params.batchName);
    return await _batchRepository.createBatch(batchEntity);
  }
}
