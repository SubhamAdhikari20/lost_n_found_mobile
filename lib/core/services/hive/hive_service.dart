import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/auth/data/models/user_hive_model.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/category/data/models/category_hive_model.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/${HiveTableConstant.dbName}";

    Hive.init(path);
    _registerAdapters();
    await _openBoxes();
    // await deleteAllBatches();
    await insertDummyBatches();
  }

  // Register all type adapters
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.batchTypeId)) {
      Hive.registerAdapter(BatchHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.categoryTypeId)) {
      Hive.registerAdapter(CategoryHiveModelAdapter());
    }
  }

  // Open all boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<BatchHiveModel>(HiveTableConstant.batchTable);
    await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryTable);
  }

  // Close all boxes
  Future<void> close() async {
    await Hive.close();
  }

  // ==================== Batch CRUD Operations ====================

  // Get batch box
  Box<BatchHiveModel> get _batchBox =>
      Hive.box<BatchHiveModel>(HiveTableConstant.batchTable);

  // Create a new batch
  Future<BatchHiveModel> createBatch(BatchHiveModel batch) async {
    await _batchBox.put(batch.batchId, batch);
    return batch;
  }

  // Get all batches
  List<BatchHiveModel> getAllBatches() {
    return _batchBox.values.toList();
  }

  // Get batch by ID
  BatchHiveModel? getBatchById(String batchId) {
    return _batchBox.get(batchId);
  }

  // Update a batch
  Future<void> updateBatch(BatchHiveModel batch) async {
    await _batchBox.put(batch.batchId, batch);
  }

  // Delete a batch
  Future<void> deleteBatch(String batchId) async {
    await _batchBox.delete(batchId);
  }

  // Delete all batches
  Future<void> deleteAllBatches() async {
    await _batchBox.clear();
  }

  // Insert Dummy Batches
  Future<void> insertDummyBatches() async {
    if (_batchBox.isNotEmpty) {
      return;
    }

    final dummyBatches = [
      BatchHiveModel(batchName: '35-A'),
      BatchHiveModel(batchName: '35-B'),
      BatchHiveModel(batchName: '35-C'),
      BatchHiveModel(batchName: '35-D'),
      BatchHiveModel(batchName: '36-A'),
      BatchHiveModel(batchName: '37-A'),
    ];

    for (var batch in dummyBatches) {
      await createBatch(batch);
    }
  }

  // ---------------------- Category CRUD Operations -------------------------
  // Get category box
  Box<CategoryHiveModel> get _categoryBox =>
      Hive.box(HiveTableConstant.categoryTable);

  // Create a new category
  Future<CategoryHiveModel?> createCategory(CategoryHiveModel category) async {
    await _categoryBox.put(category.categoryId, category);
    return category;
  }

  // Update a existing category
  Future<CategoryHiveModel?> updadeCategory(CategoryHiveModel category) async {
    await _categoryBox.put(category.categoryId, category);
    return category;
  }

  // Get a existing category by ID
  Future<CategoryHiveModel?> getCategoryByID(String categoryId) async {
    return _categoryBox.get(categoryId);
  }

  // Get all categories
  Future<List<CategoryHiveModel>> getAllCategories() async {
    return _categoryBox.values.toList();
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    await _categoryBox.delete(categoryId);
  }

  // Delete all categories
  Future<void> deleteAllCategories() async {
    await _categoryBox.clear();
  }

  // ---------------------- Auth Operations -------------------------
  // Get users box
  Box<UserHiveModel> get _usersBox =>
      Hive.box<UserHiveModel>(HiveTableConstant.userTable);

  // Sign Up
  Future<UserHiveModel?> signUp(UserHiveModel userModel) async {
    // final users = _usersBox.values.where(
    //   (user) => user.email == userModel.email,
    // );
    // if (users.isNotEmpty) {
    //   return null;
    // }
    await _usersBox.put(userModel.userId, userModel);
    return userModel;
  }

  // Login
  Future<UserHiveModel?> login(String identifier, String password) async {
    final users = _usersBox.values.where(
      (user) =>
          (user.email == identifier || user.username == identifier) &&
          user.password == password,
    );

    if (users.isEmpty) {
      return null;
    }
    return users.first;
  }

  // Logout
  Future<bool> logout() async {
    return true;
  }

  // Check Email Exists
  Future<bool> isEmailExists(String email) async {
    final users = _usersBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }

  // get current user
  Future<UserHiveModel?> getCurrentUser(String userId) async {
    return _usersBox.get(userId);
  }
}
