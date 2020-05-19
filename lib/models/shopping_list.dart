import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../datasource/network.dart';

part 'shopping_list.g.dart';

@JsonSerializable()
class ShoppingList with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  @JsonKey(name: '_id')
  String id;
  List<ShoppingListItem> items;
  String name;

  ShoppingList({@required this.id, this.items, this.name});

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

  Future<void> addShoppingListItem(
      ShoppingListItem shoppingListItem) async {
    items.add(shoppingListItem);
    notifyListeners();
    
    _restApi.addShoppingListItem(id, shoppingListItem.toJSON());
  }

  Future<void> removeItemFromList(ShoppingListItem toBeRemoved) async {
    items.removeWhere((item) => item.item == toBeRemoved.item);
    _restApi.deleteShoppingItemFromList(id, toBeRemoved.item);
    notifyListeners();
  }

  Future<void> setChecked(ShoppingListItem item, bool checked) async {
    item.checked = checked;
    _restApi.patchShoppingListItem(id, item.item, item.toJSON());
    notifyListeners();
  }

  bool containsItem(String itemId) {
    return items.map((item) => item.item).contains(itemId);
  }
}

@JsonSerializable()
class ShoppingListItem with ChangeNotifier {
  String item;
  bool checked;

  @JsonKey(includeIfNull: false)
  int quantity;
  @JsonKey(includeIfNull: false)
  String unitOfMeasure;
  @JsonKey(includeIfNull: false)
  String supermarketSection;
  @JsonKey(includeIfNull: false)
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

  Map<String, dynamic> toJSON() => _$ShoppingListItemToJson(this);
}