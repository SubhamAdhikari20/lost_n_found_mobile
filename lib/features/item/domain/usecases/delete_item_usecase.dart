import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecase.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

class DeleteItemUsecaseParams extends Equatable {
  final String itemId;

  const DeleteItemUsecaseParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

final deleteItemUsecaseProvider = Provider<DeleteItemUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return DeleteItemUsecase(itemRepository: itemRepository);
});

class DeleteItemUsecase
    implements UsecaseWithParams<bool, DeleteItemUsecaseParams> {
  final IItemRepository _itemRepository;

  DeleteItemUsecase({required IItemRepository itemRepository})
    : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteItemUsecaseParams params) async {
    return await _itemRepository.deleteItem(params.itemId);
  }
}
