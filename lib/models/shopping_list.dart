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
  @JsonKey(defaultValue: [])
  List<ShoppingListItem> items;

  @JsonKey(includeIfNull: false)
  String? name;

  ShoppingList({required String id, this.items = const [], this.name})
      : super(id: id);

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

  void setChecked(ShoppingListItem item, bool checked) {
    item.checked = checked;
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
  String item;

  bool checked;

  @JsonKey(includeIfNull: false)
  double? quantity;

  @JsonKey(includeIfNull: false)
  String? unitOfMeasure;

  @JsonKey(includeIfNull: false)
  String? supermarketSection;

  @JsonKey(includeIfNull: false)
  int? listPosition;

  ShoppingListItem(
      {required this.item,
      this.supermarketSection,
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
  String urlForSave(id, Map<String, dynamic> params) => '$dashCaseType/$id';

  String get dashCaseType =>
      type.split(RegExp('(?=[A-Z])')).join('-').toLowerCase();
}
