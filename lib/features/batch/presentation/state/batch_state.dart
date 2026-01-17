import 'package:equatable/equatable.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

enum BatchStatus { initial, loading, loaded, created, error, updated, deleted }

class BatchState extends Equatable {
  final BatchStatus batchStatus;
  final List<BatchEntity> batches;
  final String? errorMessage;

  const BatchState({
    this.batchStatus = BatchStatus.initial,
    this.batches = const [],
    this.errorMessage,
  });

  // copywith function
  BatchState copywith({
    BatchStatus? batchStatus,
    List<BatchEntity>? batches,
    String? errorMessage,
  }) {
    return BatchState(
      batchStatus: batchStatus ?? this.batchStatus,
      batches: batches ?? this.batches,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [batchStatus, batches, errorMessage];
}
