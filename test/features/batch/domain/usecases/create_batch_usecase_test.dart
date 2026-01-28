import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockBatchRepository extends Mock implements IBatchRepository {}

void main() {
  late CreateBatchUsecase createBatchUsecase;
  late MockBatchRepository mockBatchRepository;

  setUp(() {
    mockBatchRepository = MockBatchRepository();
    createBatchUsecase = CreateBatchUsecase(
      batchRepository: mockBatchRepository,
    );
  });

  setUpAll(() {
    registerFallbackValue(const BatchEntity(batchName: "fallback"));
  });

  const tBatchName = "New Batch";

  // group(("CreateBatchUsecase"), (){
  test("should return true when batch is created successfully", () async {
    // Arrange
    when(() {
      return mockBatchRepository.createBatch(any());
    }).thenAnswer((_) async {
      return const Right(true);
    });

    // Act
    final result = await createBatchUsecase(
      const CreateBatchUsecaseParams(batchName: tBatchName),
    );

    // Assert
    expect(result, const Right(true));
    verify(() {
      return mockBatchRepository.createBatch(any());
    }).called(1);
    verifyNoMoreInteractions(mockBatchRepository);
  });

  test(
    "should pass Batch Entity with correct batch name to repository",
    () async {
      // Arrange
      BatchEntity? capturedEntity;
      when(() {
        return mockBatchRepository.createBatch(any());
      }).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as BatchEntity;
        return Future.value(const Right(true));
      });

      // Act
      await createBatchUsecase(
        const CreateBatchUsecaseParams(batchName: tBatchName),
      );

      // Assert
      expect(capturedEntity?.batchName, tBatchName);
      expect(capturedEntity?.batchId, isNull);
    },
  );

  // });
}
