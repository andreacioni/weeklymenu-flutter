import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:weekly_menu_app/models/base_model.dart';
import 'package:weekly_menu_app/models/id.dart';

part 'shopping_list.g.dart';

@JsonSerializable(explicitToJson: true)
class ShoppingList extends BaseModel<ShoppingList> {
  @JsonKey(defaultValue: [])
  List<ShoppingListItem> items;

  @JsonKey(includeIfNull: false)
  String name;

  ShoppingList({
    Id idx,
    int insertTimestamp,
    int updateTimestamp,
    this.items,
    this.name,
  }) : super(
          idx: idx,
          insertTimestamp: insertTimestamp,
          updateTimestamp: updateTimestamp,
        );

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
