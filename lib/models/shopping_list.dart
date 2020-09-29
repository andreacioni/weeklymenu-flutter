import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/syncronizer/syncro.dart';

part 'shopping_list.g.dart';

@JsonSerializable(explicitToJson: true)
class ShoppingList extends BaseModel<ShoppingList> {
  @JsonKey(defaultValue: [])
  List<ShoppingListItem> items;

  @JsonKey(includeIfNull: false)
  String name;

  ShoppingList(Id id, {this.items, this.name}) : super(id);

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListToJson(this);

  List<ShoppingListItem> get getAllItems => [...items];

  List<ShoppingListItem> get getCheckedItems =>
      items.where((item) => item.checked).toList();

  List<ShoppingListItem> get getUncheckedItems =>
      items.where((item) => !item.checked).toList();

  ShoppingListItem getItemById(Id itemId) =>
      items.firstWhere((ing) => ing.ingredientId == itemId, orElse: () => null);

  void addShoppingListItem(ShoppingListItem shoppingListItem) {
    items.add(shoppingListItem);
    notifyListeners();
  }

  void removeItemFromList(ShoppingListItem toBeRemoved) {
    items.removeWhere((item) => item.ingredientId == toBeRemoved.ingredientId);
    notifyListeners();
  }

  void setChecked(ShoppingListItem item, bool checked) {
    item.checked = checked;
    notifyListeners();
  }

  bool containsItem(Id itemId) {
    return items.map((item) => item.ingredientId).contains(itemId);
  }

  @override
  ShoppingList clone() => ShoppingList.fromJson(this.toJson());
}

@JsonSerializable()
class ShoppingListItem with ChangeNotifier {
  final Id ingredientId;
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
      {this.ingredientId,
      this.supermarketSection,
      this.checked,
      this.quantity,
      this.unitOfMeasure,
      this.listPosition});

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListItemToJson(this);
}
