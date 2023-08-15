import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectid/objectid.dart';

import 'base_model.dart';
part 'shopping_list.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class ShoppingList extends BaseModel<ShoppingList> {
  @JsonKey()
  List<ShoppingListItem> items;

  @JsonKey(includeIfNull: false)
  String? name;

  ShoppingList(
      {String? idx,
      this.items = const [],
      this.name,
      int? insertTimestamp,
      int? updateTimestamp})
      : super(
            idx: idx ?? ObjectId().hexString,
            insertTimestamp: insertTimestamp,
            updateTimestamp: updateTimestamp);

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListToJson(this);

  List<ShoppingListItem> get getAllItems => [...items];

  List<ShoppingListItem> get getCheckedItems =>
      items.where((item) => item.checked).toList();

  List<ShoppingListItem> get getUncheckedItems =>
      items.where((item) => !item.checked).toList();

  ShoppingList addShoppingListItem(ShoppingListItem shoppingListItem) {
    return addAllShoppingListItem([shoppingListItem]);
  }

  ShoppingList addAllShoppingListItem(
      List<ShoppingListItem> shoppingListItemList) {
    final newList = [...shoppingListItemList, ...items];
    return this.copyWith(items: newList);
  }

  ShoppingList removeItemFromList(ShoppingListItem toBeRemoved) {
    final newList = [...items];
    newList.removeWhere(
        (item) => item.itemName.trim() == toBeRemoved.itemName.trim());
    return this.copyWith(items: newList);
  }

  ShoppingList setChecked(ShoppingListItem item, bool checked) {
    final idx = items.indexWhere((i) => i.itemName == item.itemName);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(checked: checked);
    }

    return copyWith(items: items);
  }

  ShoppingList updateItem(
      ShoppingListItem previousItem, ShoppingListItem newItem) {
    final idx = items.indexOf(previousItem);
    if (idx >= 0) {
      items.replaceRange(idx, idx + 1, [newItem]);
    }

    return copyWith(items: items);
  }

  @override
  ShoppingList clone() => ShoppingList.fromJson(toJson());
}

@JsonSerializable()
@CopyWith()
class ShoppingListItem {
  @JsonKey(name: 'name')
  final String itemName;

  final bool checked;

  @JsonKey(includeIfNull: false)
  final double? quantity;

  @JsonKey(includeIfNull: false)
  final String? unitOfMeasure;

  @JsonKey(includeIfNull: false)
  final String? supermarketSectionName;

  @JsonKey(includeIfNull: false)
  final int? listPosition;

  ShoppingListItem(
      {required this.itemName,
      this.supermarketSectionName,
      this.checked = false,
      this.quantity,
      this.unitOfMeasure,
      this.listPosition});

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListItemToJson(this);

  @override
  bool operator ==(Object other) =>
      other is ShoppingListItem &&
      other.runtimeType == runtimeType &&
      other.itemName == itemName;

  @override
  int get hashCode => itemName.hashCode;
}
