import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/item/data/datasources/item_datasource.dart';
import 'package:lost_n_found/features/item/data/datasources/local/item_local_datasource.dart';
import 'package:lost_n_found/features/item/data/datasources/remote/item_remote_datasource.dart';
import 'package:lost_n_found/features/item/data/models/item_api_model.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';

final itemRepositoryProvider = Provider<IItemRepository>((ref) {
  final localDatasource = ref.read(itemLocalDatasourceProvider);
  final remoteDatasource = ref.read(itemRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return ItemRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class ItemRepository implements IItemRepository {
  final IItemLocalDataSource _itemLocalDataSource;
  final IItemRemoteDataSource _itemRemoteDataSource;
  final INetworkInfo _networkInfo;

  ItemRepository({
    required IItemLocalDataSource localDatasource,
    required IItemRemoteDataSource remoteDatasource,
    required INetworkInfo networkInfo,
  }) : _itemLocalDataSource = localDatasource,
       _itemRemoteDataSource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, ItemEntity>> createItem(ItemEntity item) async {
    if (await _networkInfo.isConnected) {
      try {
        final itemApiModel = ItemApiModel.fromEntity(item);

        final result = await _itemRemoteDataSource.createItem(itemApiModel);
        if (result == null) {
          return const Left(ApiFailure(message: "Failed to create item!"));
        }

        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to create item!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final itemHiveModel = ItemHiveModel.fromEntity(item);

        final result = await _itemLocalDataSource.createItem(itemHiveModel);
        if (result == null) {
          return Left(LocalDatabaseFailure(message: "Failed to create item!"));
        }

        return Right(result.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteItem(String itemId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _itemRemoteDataSource.deleteItem(itemId);
        if (!result) {
          ApiFailure(message: "Failed to delete item!");
        }

        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to delete item!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _itemLocalDataSource.deleteItem(itemId);
        if (!result) {
          return const Left(
            LocalDatabaseFailure(message: "Failed to delete item!"),
          );
        }

        return Right(result);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getAllItems() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _itemRemoteDataSource.getAllItems();
        if (result.isEmpty) {
          return Left(ApiFailure(message: "Failed! Items are empty."));
        }

        final entities = ItemApiModel.toEntityList(result);

        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to fetch all items",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _itemLocalDataSource.getAllItems();
        if (result.isEmpty) {
          return Left(
            LocalDatabaseFailure(message: "Failed! Items are empty."),
          );
        }

        final entities = ItemHiveModel.toEntityList(result);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> getItemById(String itemId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _itemRemoteDataSource.getItemById(itemId);
        if (result == null) {
          return const Left(
            ApiFailure(message: "Failed! Item not found by id."),
          );
        }

        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data["message"] ?? "Failed to get the item by id!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _itemLocalDataSource.getItemById(itemId);
        if (result == null) {
          return const Left(
            LocalDatabaseFailure(message: "Failed! Item not found by id."),
          );
        }

        return Right(result.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getFoundItems() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _itemRemoteDataSource.getFoundItems();
        if (result.isEmpty) {
          return const Left(
            ApiFailure(message: "Failed! Found items are empty."),
          );
        }

        final entities = ItemApiModel.toEntityList(result);
        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to get found item!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _itemLocalDataSource.getFoundItems();
        if (result.isEmpty) {
          return const Left(
            LocalDatabaseFailure(message: "Failed! Found items are empty."),
          );
        }

        final entities = ItemHiveModel.toEntityList(result);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsByCategory(
    String categoryId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _itemRemoteDataSource.getItemsByCategory(
          categoryId,
        );
        if (result.isEmpty) {
          return const Left(
            ApiFailure(message: "Failed! Items are empty by category."),
          );
        }

        final entities = ItemApiModel.toEntityList(result);
        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data["message"] ??
                "Failed to get items by category!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _itemLocalDataSource.getItemsByCategory(
          categoryId,
        );
        if (result.isEmpty) {
          return const Left(
            LocalDatabaseFailure(
              message: "Failed! Items are empty by category.",
            ),
          );
        }

        final entities = ItemHiveModel.toEntityList(result);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsByUser(
    String userId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _itemRemoteDataSource.getItemsByUser(userId);
        if (result.isEmpty) {
          return const Left(
            ApiFailure(message: "Failed! Items are empty by user."),
          );
        }

        final entities = ItemApiModel.toEntityList(result);
        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data["message"] ?? "Failed to get items by user!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _itemLocalDataSource.getItemsByUser(userId);
        if (result.isEmpty) {
          return const Left(
            LocalDatabaseFailure(message: "Failed! Lost items are empty."),
          );
        }

        final entities = ItemHiveModel.toEntityList(result);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getLostItems() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _itemRemoteDataSource.getLostItems();
        if (result.isEmpty) {
          return const Left(
            ApiFailure(message: "Failed! Lost items are empty."),
          );
        }

        final entities = ItemApiModel.toEntityList(result);
        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to get lost item!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _itemLocalDataSource.getLostItems();
        if (result.isEmpty) {
          return const Left(
            LocalDatabaseFailure(message: "Failed! Lost items are empty."),
          );
        }

        final entities = ItemHiveModel.toEntityList(result);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> updateItem(ItemEntity item) async {
    if (await _networkInfo.isConnected) {
      try {
        final itemApiModel = ItemApiModel.fromEntity(item);

        final result = await _itemRemoteDataSource.updateItem(itemApiModel);
        if (result == null) {
          return const Left(
            ApiFailure(message: "Failed! item is not updated."),
          );
        }

        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to update item!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final itemModel = ItemHiveModel.fromEntity(item);
        final result = await _itemLocalDataSource.updateItem(itemModel);
        if (result == null) {
          return const Left(
            LocalDatabaseFailure(message: "Failed to update item"),
          );
        }
        return Right(result.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(File photo) async {
    if (await _networkInfo.isConnected) {
      try {
        final url = await _itemRemoteDataSource.uploadPhoto(photo);
        if (url == null) {
          return const Left(
            ApiFailure(
              message: "Null image url! The image url is not fetched.",
            ),
          );
        }

        return Right(url);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to upload image!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, String>> uploadVideo(File video) async {
    if (await _networkInfo.isConnected) {
      try {
        final url = await _itemRemoteDataSource.uploadVideo(video);
        if (url == null) {
          return const Left(
            ApiFailure(
              message: "Null video url! The image video is not fetched.",
            ),
          );
        }

        return Right(url);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Failed to upload video!",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: "No internet connection"));
    }
  }
}
