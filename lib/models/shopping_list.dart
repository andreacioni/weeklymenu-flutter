import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/models/base_model.dart';

import '../datasource/network.dart';

part 'shopping_list.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 4)
class ShoppingList extends BaseModel<ShoppingList> {
  @JsonKey(defaultValue: [])
  @HiveField(1)
  List<ShoppingListItem> items;

  @JsonKey(includeIfNull: false)
  @HiveField(2)
  String name;

  ShoppingList({String id, this.items, this.name}) : super(id: id);

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListToJson(this);

  List<ShoppingListItem> get getAllItems => [...items];

  List<ShoppingListItem> get getCheckedItems =>
      items.where((item) => item.checked).toList();

  List<ShoppingListItem> get getUncheckedItems =>
      items.where((item) => !item.checked).toList();

  ShoppingListItem getItemById(String itemId) =>
      items.firstWhere((ing) => ing.item == itemId, orElse: () => null);

  void addShoppingListItem(ShoppingListItem shoppingListItem) {
    items.add(shoppingListItem);
    notifyListeners();
  }

  void removeItemFromList(ShoppingListItem toBeRemoved) {
    items.removeWhere((item) => item.item == toBeRemoved.item);
    notifyListeners();
  }

  void setChecked(ShoppingListItem item, bool checked) {
    item.checked = checked;
    notifyListeners();
  }

  bool containsItem(String itemId) {
    return items.map((item) => item.item).contains(itemId);
  }

  @override
  ShoppingList clone() => ShoppingList.fromJson(this.toJson());
}

@JsonSerializable()
@HiveType(typeId: 6)
class ShoppingListItem with ChangeNotifier {
  @HiveField(1)
  String item;

  @HiveField(2)
  bool checked;

  @JsonKey(includeIfNull: false)
  @HiveField(3)
  double quantity;

  @JsonKey(includeIfNull: false)
  @HiveField(4)
  String unitOfMeasure;

  @JsonKey(includeIfNull: false)
  @HiveField(5)
  String supermarketSection;

  @JsonKey(includeIfNull: false)
  @HiveField(6)
  int listPosition;

  ShoppingListItem(
      {this.item,
      this.supermarketSection,
      this.checked,
      this.quantity,
      this.unitOfMeasure,
      this.listPosition});

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListItemToJson(this);
}
