import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:objectid/objectid.dart';

import 'base_model.dart';
import '../globals/constants.dart';
part 'shopping_list.g.dart';

const SHOPPING_LIST_ID_PARAM = 'shopping_list_id';

@JsonSerializable(explicitToJson: true)
@DataRepository([BaseAdapter, ShoppingListAdapter],
    internalType: 'shopping-lists')
@CopyWith()
class ShoppingList extends BaseModel<ShoppingList> {
  @JsonKey()
  List<ShoppingListItem> items;

  @JsonKey(includeIfNull: false)
  String? name;

  ShoppingList(
      {String? id,
      this.items = const [],
      this.name,
      int? insertTimestamp,
      int? updateTimestamp})
      : super(
            id: id ?? ObjectId().hexString,
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

  ShoppingListItem getItemById(String itemId) =>
      items.firstWhere((ing) => ing.item == itemId);

  void addShoppingListItem(ShoppingListItem shoppingListItem) {
    items.add(shoppingListItem);
  }

  void removeItemFromList(ShoppingListItem toBeRemoved) {
    items.removeWhere((item) => item.item == toBeRemoved.item);
  }

  ShoppingList setChecked(ShoppingListItem item, bool checked) {
    final idx = items.indexWhere((i) => i == item);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(checked: checked);
    }

    return copyWith(items: items);
  }

  bool containsItem(String itemId) {
    return items.map((item) => item.item).contains(itemId);
  }

  @override
  ShoppingList clone() => ShoppingList.fromJson(this.toJson());
}

@JsonSerializable()
@CopyWith()
@DataRepository([BaseAdapter, ShoppingListItemAdapter],
    internalType: 'shopping-list-items')
class ShoppingListItem extends DataModel<ShoppingListItem> {
  final String item;
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
      {required this.item,
      required this.itemName,
      this.supermarketSectionName,
      this.checked = false,
      this.quantity,
      this.unitOfMeasure,
      this.listPosition});

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListItemToJson(this);

  @override
  String get id => item;
}

mixin ShoppingListAdapter<T extends DataModel<ShoppingList>>
    on RemoteAdapter<ShoppingList> {
  @override
  String urlForFindAll(Map<String, dynamic> params) => dashCaseType;

  @override
  String urlForFindOne(id, Map<String, dynamic> params) => '$dashCaseType/$id';

  @override
  String urlForSave(id, Map<String, dynamic> params) =>
      params[UPDATE_PARAM] == true ? '$dashCaseType/$id' : dashCaseType;

  String get dashCaseType =>
      type.split(RegExp('(?=[A-Z])')).join('-').toLowerCase();
}

mixin ShoppingListItemAdapter<T extends DataModel<ShoppingListItem>>
    on RemoteAdapter<ShoppingListItem> {
  @override
  String urlForFindAll(Map<String, dynamic> params) {
    final url = basePath(params[SHOPPING_LIST_ID_PARAM]);
    return '$url';
  }

  @override
  String urlForFindOne(id, Map<String, dynamic> params) {
    final url = basePath(params[SHOPPING_LIST_ID_PARAM]);
    return '$url/$id';
  }

  @override
  String urlForSave(id, Map<String, dynamic> params) {
    final url = basePath(params[SHOPPING_LIST_ID_PARAM]);
    return params[UPDATE_PARAM] == true ? "$url/$id" : url;
  }

  @override
  String urlForDelete(id, Map<String, dynamic> params) {
    final url = basePath(params[SHOPPING_LIST_ID_PARAM]);
    return '$url/$id';
  }

  String basePath(String shoppingListId) =>
      "shopping-lists/$shoppingListId/items";
}
