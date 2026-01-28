import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';

abstract interface class IItemRepository {
  Future<Either<Failure, ItemEntity>> createItem(ItemEntity item);
  Future<Either<Failure, ItemEntity>> updateItem(ItemEntity item);
  Future<Either<Failure, bool>> deleteItem(String itemId);
  Future<Either<Failure, String>> uploadPhoto(File photo);
  Future<Either<Failure, String>> uploadVideo(File video);

Future<Either<Failure, ItemEntity>> getItemById(String itemId);
  Future<Either<Failure, List<ItemEntity>>> getAllItems();
  Future<Either<Failure, List<ItemEntity>>> getItemsByUser(String userId);
  Future<Either<Failure, List<ItemEntity>>> getLostItems();
  Future<Either<Failure, List<ItemEntity>>> getFoundItems();
  Future<Either<Failure, List<ItemEntity>>> getItemsByCategory(
    String categoryId,
  );
}
