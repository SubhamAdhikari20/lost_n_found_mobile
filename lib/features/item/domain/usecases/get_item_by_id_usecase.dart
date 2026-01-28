import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecase.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

class GetItemByIdUsecaseParams extends Equatable {
  final String itemId;

  const GetItemByIdUsecaseParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

final getItemByIdUsecaseProvider = Provider<GetItemByIdUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return GetItemByIdUsecase(itemRepository: itemRepository);
});

class GetItemByIdUsecase
    implements UsecaseWithParams<ItemEntity, GetItemByIdUsecaseParams> {
  final IItemRepository _itemRepository;

  GetItemByIdUsecase({required IItemRepository itemRepository})
    : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, ItemEntity>> call(
    GetItemByIdUsecaseParams params,
  ) async {
    return await _itemRepository.getItemById(params.itemId);
  }
}
