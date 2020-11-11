import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/models/base_model.dart';

import 'package:flutter_data/flutter_data.dart';
import 'package:weekly_menu_app/models/ingredient.dart';

part 'shopping_list.g.dart';

@JsonSerializable(explicitToJson: true)
@DataRepository([BaseAdapter, ShoppingListAdapter])
class ShoppingList extends BaseModel<ShoppingList> {
  @JsonKey(defaultValue: [])
  List<ShoppingListItem> items;

  @JsonKey(includeIfNull: false)
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
class ShoppingListItem with ChangeNotifier {
  String item;

  bool checked;

  @JsonKey(includeIfNull: false)
  double quantity;

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
