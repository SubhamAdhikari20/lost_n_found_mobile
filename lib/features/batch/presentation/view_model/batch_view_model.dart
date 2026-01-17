import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/delete_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batches_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_batch_by_id_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:lost_n_found/features/batch/presentation/state/batch_state.dart';

// Batch View Model Notifier Provider
final batchViewModelProvider = NotifierProvider<BatchViewModel, BatchState>(() {
  return BatchViewModel();
});

class BatchViewModel extends Notifier<BatchState> {
  late final CreateBatchUsecase _createBatchUsecase;
  late final UpdateBatchUsecase _updateBatchUsecase;
  late final GetAllBatchesUsecase _getAllBatchesUsecase;
  late final GetBatchByIdUsecase _getBatchByIdUsecase;
  late final DeleteBatchUsecase _deleteBatchUsecase;

  @override
  BatchState build() {
    // Initialize
    _createBatchUsecase = ref.read(createBatchUsecaseProvider);
    _updateBatchUsecase = ref.read(updateBatchUsecaseProvider);
    _getAllBatchesUsecase = ref.read(getAllBatchesUsecaseProvider);
    _getBatchByIdUsecase = ref.read(getBatchByIdUsecaseProvider);
    _deleteBatchUsecase = ref.read(deleteBatchUsecaseProvider);
    return BatchState();
  }

  Future<void> getAllBatches() async {
    state = state.copywith(batchStatus: BatchStatus.loading);

    // Wait for few seconds
    await Future.delayed(Duration(seconds: 3));
    final result = await _getAllBatchesUsecase();

    result.fold(
      (failure) {
        state = state.copywith(
          batchStatus: BatchStatus.error,
          errorMessage: failure.message,
        );
      },
      (batches) {
        state = state.copywith(
          batchStatus: BatchStatus.loaded,
          batches: batches,
        );
      },
    );
  }

  Future<void> createBatch({required String batchName}) async {
    state = state.copywith(batchStatus: BatchStatus.loading);

    final createBatchUsecaseParams = CreateBatchUsecaseParams(
      batchName: batchName,
    );

    // Wait for few seconds
    await Future.delayed(Duration(seconds: 3));
    final result = await _createBatchUsecase(createBatchUsecaseParams);

    result.fold(
      (failure) {
        state = state.copywith(
          batchStatus: BatchStatus.error,
          errorMessage: failure.message,
        );
      },
      (isCreated) {
        state = state.copywith(batchStatus: BatchStatus.created);
      },
    );
  }

  Future<void> updateBatch({
    required String batchId,
    required String batchName,
    String? status,
  }) async {
    state = state.copywith(batchStatus: BatchStatus.loading);

    final updateBatchUsecaseParams = UpdateBatchUsecasParams(
      batchId: batchId,
      batchName: batchName,
      status: status,
    );

    // Wait for few seconds
    await Future.delayed(Duration(seconds: 3));
    final result = await _updateBatchUsecase(updateBatchUsecaseParams);

    result.fold(
      (failure) {
        state = state.copywith(
          batchStatus: BatchStatus.error,
          errorMessage: failure.message,
        );
      },
      (isCreated) {
        state = state.copywith(batchStatus: BatchStatus.updated);
      },
    );
  }

  Future<void> getBatchById({required String batchId}) async {
    state = state.copywith(batchStatus: BatchStatus.loading);

    final getBatchByIdUsecaseParams = GetBatchByIdUsecaseParams(
      batchId: batchId,
    );

    // Wait for few seconds
    await Future.delayed(Duration(seconds: 3));
    final result = await _getBatchByIdUsecase(getBatchByIdUsecaseParams);

    result.fold(
      (failure) {
        state = state.copywith(
          batchStatus: BatchStatus.error,
          errorMessage: failure.message,
        );
      },
      (batch) {
        state = state.copywith(batchStatus: BatchStatus.loaded);
      },
    );
  }

  Future<void> deleteBatch({required String batchId}) async {
    state = state.copywith(batchStatus: BatchStatus.loading);

    final deleteBatchUsecaseParams = DeleteBatchUsecaseParams(batchId: batchId);

    // Wait for few seconds
    await Future.delayed(Duration(seconds: 3));
    final result = await _deleteBatchUsecase(deleteBatchUsecaseParams);

    result.fold(
      (failure) {
        state = state.copywith(
          batchStatus: BatchStatus.error,
          errorMessage: failure.message,
        );
      },
      (isDeleted) {
        state = state.copywith(batchStatus: BatchStatus.deleted);
      },
    );
  }
}
