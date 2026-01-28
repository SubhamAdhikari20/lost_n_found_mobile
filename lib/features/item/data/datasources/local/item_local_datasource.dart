import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/services/hive/hive_service.dart';
import 'package:lost_n_found/features/item/data/datasources/item_datasource.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';

final itemLocalDatasourceProvider = Provider<IItemLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return ItemLocalDatasource(hiveService: hiveService);
});

class ItemLocalDatasource implements IItemLocalDataSource {
  final HiveService _hiveService;

  ItemLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<ItemHiveModel?> createItem(ItemHiveModel item) async {
    try {
      final result = await _hiveService.createItem(item);
      return Future.value(result);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deleteItem(String itemId) async {
    try {
      final result = await _hiveService.deleteItem(itemId);
      return Future.value(result);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ItemHiveModel>> getAllItems() async {
    try {
      final result = _hiveService.getAllItems();
      return Future.value(result);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemHiveModel>> getFoundItems() async {
    try {
      final result = _hiveService.getFoundItems();
      return Future.value(result);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ItemHiveModel?> getItemById(String itemId) async {
    try {
      final result = _hiveService.getItemById(itemId);
      return Future.value(result);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ItemHiveModel>> getItemsByCategory(String categoryId) async {
    try {
      final result = _hiveService.getItemsByCategory(categoryId);
      return Future.value(result);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemHiveModel>> getItemsByUser(String userId) async {
    try {
      final result = _hiveService.getItemsByUser(userId);
      return Future.value(result);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ItemHiveModel>> getLostItems() async {
    try {
      final result = _hiveService.getLostItems();
      return Future.value(result);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ItemHiveModel?> updateItem(ItemHiveModel item) async {
    try {
      final result = await _hiveService.updateItem(item);
      return Future.value(result);
    } catch (e) {
      return null;
    }
  }
}
