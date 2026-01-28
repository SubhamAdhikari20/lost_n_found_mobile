import 'package:equatable/equatable.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';

enum ItemStatus { initial, loading, loaded, error, created, updated, deleted }

class ItemState extends Equatable {
  final ItemStatus itemStatus;
  final List<ItemEntity> items;
  final List<ItemEntity> lostItems;
  final List<ItemEntity> foundItems;
  final List<ItemEntity> myLostItems;
  final List<ItemEntity> myFoundItems;
  final ItemEntity? selectedItem;
  final String? errorMessage;
  final String? uploadedUrl;

  const ItemState({
    this.itemStatus = ItemStatus.initial,
    this.items = const [],
    this.lostItems = const [],
    this.foundItems = const [],
    this.myLostItems = const [],
    this.myFoundItems = const [],
    this.selectedItem,
    this.errorMessage,
    this.uploadedUrl,
  });

  // copywith function
  ItemState copyWith({
    ItemStatus? itemStatus,
    List<ItemEntity>? items,
    List<ItemEntity>? lostItems,
    List<ItemEntity>? foundItems,
    List<ItemEntity>? myLostItems,
    List<ItemEntity>? myFoundItems,
    ItemEntity? selectedItem,
    bool resetSelectedItem = false,
    bool resetErrorMessage = false,
    String? uploadedUrl,
    bool resetUploadedUrl = false,
    String? errorMessage,
  }) {
    return ItemState(
      itemStatus: itemStatus ?? this.itemStatus,
      items: items ?? this.items,
      lostItems: lostItems ?? this.lostItems,
      foundItems: foundItems ?? this.foundItems,
      myLostItems: myLostItems ?? this.myLostItems,
      myFoundItems: myFoundItems ?? this.myFoundItems,
      selectedItem: resetSelectedItem
          ? null
          : (selectedItem ?? this.selectedItem),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      uploadedUrl: resetUploadedUrl
          ? null
          : (uploadedUrl ?? this.uploadedUrl),
    );
  }

  @override
  List<Object?> get props => [
    itemStatus,
    items,
    lostItems,
    foundItems,
    myLostItems,
    myFoundItems,
    selectedItem,
    errorMessage,
    uploadedUrl,
  ];
}
