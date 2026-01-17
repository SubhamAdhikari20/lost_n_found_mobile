import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecase.dart';
import 'package:lost_n_found/features/batch/data/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

final getAllBatchesUsecaseProvider = Provider<GetAllBatchesUsecase>((ref) {
  final batchRepository = ref.read(batchRepositoryProvider);
  return GetAllBatchesUsecase(batchRepository: batchRepository);
});

class GetAllBatchesUsecase implements UsecaseWithoutParams<List<BatchEntity>> {
  final IBatchRepository _batchRepository;

  GetAllBatchesUsecase({required IBatchRepository batchRepository})
    : _batchRepository = batchRepository;

  @override
  Future<Either<Failure, List<BatchEntity>>> call() async {
    return await _batchRepository.getAllBatches();
  }
}
