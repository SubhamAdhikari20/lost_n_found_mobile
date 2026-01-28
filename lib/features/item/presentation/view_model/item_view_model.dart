import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/usecases/create_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_items_by_user_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/update_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/upload_item_photo_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/upload_item_video_usecase.dart';
import 'package:lost_n_found/features/item/presentation/state/item_state.dart';

final itemViewModelProvider = NotifierProvider<ItemViewModel, ItemState>(() {
  return ItemViewModel();
});

class ItemViewModel extends Notifier<ItemState> {
  late final GetAllItemsUsecase _getAllItemsUsecase;
  late final GetItemByIdUsecase _getItemByIdUsecase;
  late final GetItemsByUserUsecase _getItemsByUserUsecase;
  late final CreateItemUsecase _createItemUsecase;
  late final UpdateItemUsecase _updateItemUsecase;
  late final DeleteItemUsecase _deleteItemUsecase;
  late final UploadItemPhotoUsecase _uploadItemPhotoUsecase;
  late final UploadItemVideoUsecase _uploadItemVideoUsecase;

  @override
  ItemState build() {
    _getAllItemsUsecase = ref.read(getAllItemsUsecaseProvider);
    _getItemByIdUsecase = ref.read(getItemByIdUsecaseProvider);
    _getItemsByUserUsecase = ref.read(getItemsByUserUsecaseProvider);
    _createItemUsecase = ref.read(createItemUsecaseProvider);
    _updateItemUsecase = ref.read(updateItemUsecaseProvider);
    _deleteItemUsecase = ref.read(deleteItemUsecaseProvider);
    _uploadItemPhotoUsecase = ref.read(uploadItemPhotoUsecaseProvider);
    _uploadItemVideoUsecase = ref.read(uploadItemVideoUsecaseProvider);
    return ItemState();
  }

  Future<void> getAllItems() async {
    state = state.copyWith(itemStatus: ItemStatus.loading);

    final result = await _getAllItemsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        itemStatus: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (items) {
        final lostItems = items
            .where((item) => item.type == ItemType.lost)
            .toList();
        final foundItems = items
            .where((item) => item.type == ItemType.found)
            .toList();
        state = state.copyWith(
          itemStatus: ItemStatus.loaded,
          items: items,
          lostItems: lostItems,
          foundItems: foundItems,
        );
      },
    );
  }

  Future<void> getItemById(String itemId) async {
    state = state.copyWith(itemStatus: ItemStatus.loading);

    final result = await _getItemByIdUsecase(
      GetItemByIdUsecaseParams(itemId: itemId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        itemStatus: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (item) => state = state.copyWith(
        itemStatus: ItemStatus.loaded,
        selectedItem: item,
      ),
    );
  }

  Future<void> getMyItems(String userId) async {
    state = state.copyWith(itemStatus: ItemStatus.loading);

    final result = await _getItemsByUserUsecase(
      GetItemsByUserParams(userId: userId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        itemStatus: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (items) {
        final myLostItems = items
            .where((item) => item.type == ItemType.lost)
            .toList();
        final myFoundItems = items
            .where((item) => item.type == ItemType.found)
            .toList();
        state = state.copyWith(
          itemStatus: ItemStatus.loaded,
          myLostItems: myLostItems,
          myFoundItems: myFoundItems,
        );
      },
    );
  }

  Future<void> createItem({
    required String itemName,
    String? description,
    String? category,
    required String location,
    required ItemType type,
    String? reportedBy,
    String? media,
    String? mediaType,
  }) async {
    state = state.copyWith(itemStatus: ItemStatus.loading);

    // Wait for few seconds
    await Future.delayed(Duration(seconds: 3));
    final result = await _createItemUsecase(
      CreateItemUsecaseParams(
        itemName: itemName,
        description: description,
        category: category,
        location: location,
        type: type,
        reportedBy: reportedBy,
        media: media,
        mediaType: mediaType,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        itemStatus: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(
          itemStatus: ItemStatus.created,
          resetUploadedUrl: true,
        );
        getAllItems();
      },
    );
  }

  Future<void> updateItem({
    required String itemId,
    required String itemName,
    String? description,
    String? category,
    required String location,
    required ItemType type,
    String? claimedBy,
    String? media,
    String? mediaType,
    bool? isClaimed,
    String? itemStatus,
  }) async {
    state = state.copyWith(itemStatus: ItemStatus.loading);

    final result = await _updateItemUsecase(
      UpdateItemUsecaseParams(
        itemId: itemId,
        itemName: itemName,
        description: description,
        category: category,
        location: location,
        type: type,
        claimedBy: claimedBy,
        media: media,
        mediaType: mediaType,
        isClaimed: isClaimed,
        status: itemStatus,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        itemStatus: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(itemStatus: ItemStatus.updated);
        getAllItems();
      },
    );
  }

  Future<void> deleteItem(String itemId) async {
    state = state.copyWith(itemStatus: ItemStatus.loading);

    final result = await _deleteItemUsecase(
      DeleteItemUsecaseParams(itemId: itemId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        itemStatus: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(itemStatus: ItemStatus.deleted);
        getAllItems();
      },
    );
  }

  Future<void> uploadItemPhoto({required File itemPhoto}) async {
    state = state.copyWith(itemStatus: ItemStatus.loading);
    final uploadItemPhotoParams = UploadItemPhotoUsecaseParams(
      itemPhoto: itemPhoto,
    );

    // Wait for few seconds
    await Future.delayed(Duration(seconds: 3));
    final result = await _uploadItemPhotoUsecase(uploadItemPhotoParams);

    result.fold(
      (failure) {
        state = state.copyWith(
          itemStatus: ItemStatus.error,
          errorMessage: failure.message,
        );
      },
      (photoUrl) {
        state = state.copyWith(
          itemStatus: ItemStatus.loaded,
          uploadedUrl: photoUrl,
        );
      },
    );
  }

  Future<void> uploadItemVideo({required File itemVideo}) async {
    state = state.copyWith(itemStatus: ItemStatus.loading);
    final uploadItemVideoParams = UploadItemVideoUsecaseParams(
      itemVideo: itemVideo,
    );

    // Wait for few seconds
    await Future.delayed(Duration(seconds: 3));
    final result = await _uploadItemVideoUsecase(uploadItemVideoParams);

    result.fold(
      (failure) {
        state = state.copyWith(
          itemStatus: ItemStatus.error,
          errorMessage: failure.message,
        );
      },
      (videoUrl) {
        state = state.copyWith(
          itemStatus: ItemStatus.loaded,
          uploadedUrl: videoUrl,
        );
      },
    );
  }
}
