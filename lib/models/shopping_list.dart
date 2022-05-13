import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/models/base_model.dart';

import 'package:flutter_data/flutter_data.dart';

part 'shopping_list.g.dart';

@JsonSerializable(explicitToJson: true)
@DataRepository([BaseAdapter, ShoppingListAdapter])
@CopyWith()
class ShoppingList extends BaseModel<ShoppingList> {
  @JsonKey()
  List<ShoppingListItem> items;

  @JsonKey(includeIfNull: false)
  String? name;

  ShoppingList(
      {required String id,
      this.items = const [],
      this.name,
      int? insertTimestamp,
      int? updateTimestamp})
      : super(
            id: id,
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

    return copyWith(items: items).was(this);
  }

  bool containsItem(String itemId) {
    return items.map((item) => item.item).contains(itemId);
  }

  @override
  ShoppingList clone() => ShoppingList.fromJson(this.toJson());
}

@JsonSerializable()
@CopyWith()
class ShoppingListItem with ChangeNotifier {
  final String item;

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
      this.supermarketSectionName,
      this.checked = false,
      this.quantity,
      this.unitOfMeasure,
      this.listPosition});

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListItemToJson(this);
}

mixin ShoppingListAdapter<T extends DataModel<ShoppingList>>
    on RemoteAdapter<ShoppingList> {
  @override
  String urlForFindAll(Map<String, dynamic> params) => dashCaseType;

  @override
  String urlForFindOne(id, Map<String, dynamic> params) => '$dashCaseType/$id';

  @override
  String urlForSave(id, Map<String, dynamic> params) =>
      params['update'] == true ? '$dashCaseType/$id' : dashCaseType;

  String get dashCaseType =>
      type.split(RegExp('(?=[A-Z])')).join('-').toLowerCase();
}
