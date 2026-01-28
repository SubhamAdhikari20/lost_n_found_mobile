import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecase.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

class UploadItemVideoUsecaseParams extends Equatable {
  final File itemVideo;

  const UploadItemVideoUsecaseParams({required this.itemVideo});

  @override
  List<Object?> get props => [itemVideo];
}

final uploadItemVideoUsecaseProvider = Provider<UploadItemVideoUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return UploadItemVideoUsecase(itemRepository: itemRepository);
});

class UploadItemVideoUsecase
    implements UsecaseWithParams<String, UploadItemVideoUsecaseParams> {
  final IItemRepository _itemRepository;

  UploadItemVideoUsecase({required IItemRepository itemRepository})
    : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, String>> call(
    UploadItemVideoUsecaseParams params,
  ) async {
    return await _itemRepository.uploadVideo(params.itemVideo);
  }
}
