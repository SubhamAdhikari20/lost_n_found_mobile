import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/delete_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batches_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_batch_by_id_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:lost_n_found/features/batch/presentation/state/batch_state.dart';
import 'package:lost_n_found/features/batch/presentation/view_model/batch_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllBatchesUsecase extends Mock implements GetAllBatchesUsecase {}

class MockGetBatchByIdUsecase extends Mock implements GetBatchByIdUsecase {}

class MockCreateBatchUsecase extends Mock implements CreateBatchUsecase {}

class MockUpdateBatchUsecase extends Mock implements UpdateBatchUsecase {}

class MockDeleteBatchUsecase extends Mock implements DeleteBatchUsecase {}

void main() {
  late MockGetAllBatchesUsecase mockGetAllBatchesUsecase;
  late MockGetBatchByIdUsecase mockGetBatchByIdUsecase;
  late MockCreateBatchUsecase mockCreateBatchUsecase;
  late MockUpdateBatchUsecase mockUpdateBatchUsecase;
  late MockDeleteBatchUsecase mockDeleteBatchUsecase;
  late ProviderContainer providerContainer;

  setUpAll(() {
    registerFallbackValue(
      const CreateBatchUsecaseParams(batchName: "fallback"),
    );
    registerFallbackValue(const GetBatchByIdUsecaseParams(batchId: "fallback"));
    registerFallbackValue(
      const UpdateBatchUsecasParams(batchId: "fallback", batchName: "fallback"),
    );
    registerFallbackValue(const DeleteBatchUsecaseParams(batchId: "fallback"));
  });

  setUp(() {
    mockGetAllBatchesUsecase = MockGetAllBatchesUsecase();
    mockGetBatchByIdUsecase = MockGetBatchByIdUsecase();
    mockCreateBatchUsecase = MockCreateBatchUsecase();
    mockUpdateBatchUsecase = MockUpdateBatchUsecase();
    mockDeleteBatchUsecase = MockDeleteBatchUsecase();

    providerContainer = ProviderContainer(
      overrides: [
        getAllBatchesUsecaseProvider.overrideWithValue(
          mockGetAllBatchesUsecase,
        ),
        getBatchByIdUsecaseProvider.overrideWithValue(mockGetBatchByIdUsecase),
        createBatchUsecaseProvider.overrideWithValue(mockCreateBatchUsecase),
        updateBatchUsecaseProvider.overrideWithValue(mockUpdateBatchUsecase),
        deleteBatchUsecaseProvider.overrideWithValue(mockDeleteBatchUsecase),
      ],
    );
  });

  tearDown(() {
    providerContainer.dispose();
  });

  final tBatches = [
    const BatchEntity(batchId: "1", batchName: "Batch 1", status: "active"),
    const BatchEntity(batchId: "2", batchName: "Batch 2", status: "active"),
  ];

  const tBatch = BatchEntity(
    batchId: "1",
    batchName: "Test Batch",
    status: "active",
  );

  group("get all batches", () {
    test("should emit loading then loaded state when successful", () async {
      // Arrange
      when(() {
        return mockGetAllBatchesUsecase();
      }).thenAnswer((_) async {
        return Right(tBatches);
      });

      final viewModel = providerContainer.read(batchViewModelProvider.notifier);

      // Act
      await viewModel.getAllBatches();

      // Assert
      final state = providerContainer.read(batchViewModelProvider);
      expect(state.batchStatus, BatchStatus.loaded);
      expect(state.batches, tBatches);
      verify(() => mockGetAllBatchesUsecase()).called(1);
    });

    test("should emit loading then error state when failed", () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to fetch batches');
      when(() {
        return mockGetAllBatchesUsecase();
      }).thenAnswer((_) async {
        return const Left(failure);
      });

      final viewModel = providerContainer.read(batchViewModelProvider.notifier);

      // Act
      await viewModel.getAllBatches();

      // Assert
      final state = providerContainer.read(batchViewModelProvider);
      expect(state.batchStatus, BatchStatus.error);
      expect(state.errorMessage, 'Failed to fetch batches');
      verify(() => mockGetAllBatchesUsecase()).called(1);
    });
  });
}
