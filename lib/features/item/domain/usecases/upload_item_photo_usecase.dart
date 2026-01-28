import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecase.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

class UploadItemPhotoUsecaseParams extends Equatable {
  final File itemPhoto;

  const UploadItemPhotoUsecaseParams({required this.itemPhoto});

  @override
  List<Object?> get props => [itemPhoto];
}

final uploadItemPhotoUsecaseProvider = Provider<UploadItemPhotoUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return UploadItemPhotoUsecase(itemRepository: itemRepository);
});

class UploadItemPhotoUsecase
    implements UsecaseWithParams<String, UploadItemPhotoUsecaseParams> {
  final IItemRepository _itemRepository;

  UploadItemPhotoUsecase({required IItemRepository itemRepository})
    : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, String>> call(
    UploadItemPhotoUsecaseParams params,
  ) async {
    return await _itemRepository.uploadPhoto(params.itemPhoto);
  }
}
