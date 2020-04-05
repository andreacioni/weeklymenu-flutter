import 'package:flutter/material.dart';


class ShoppingList with ChangeNotifier  {
  String id;
  List<ShoppingListItem> items;
  String name;

  ShoppingList({@required this.id, this.items, this.name});


  factory ShoppingList.fromJSON(Map<String, dynamic> jsonMap) {
    return ShoppingList(
      id: jsonMap['_id'],
      items: jsonMap['items'] != null
            ? jsonMap['items']
                .map((shopItemMap) => ShoppingListItem.fromJSON(
                    jsonMap['_id'], shopItemMap))
                .toList()
                .cast<ShoppingListItem>()
            : [],
      name: jsonMap['name'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      '_id': id,
      'items' : items != null
          ? items
              .map((shopItem) => shopItem.toJSON())
              .toList()
          : [],
      'name': name,
    };
  }
}

class ShoppingListItem with ChangeNotifier  {
  String item;
  String quantity;
  String unitOfMeasure;
  String supermarketSection;
  bool checked;

  ShoppingListItem({this.item, this.supermarketSection, this.checked});


  factory ShoppingListItem.fromJSON(String shopListId, Map<String, dynamic> jsonMap) {
    return ShoppingListItem(
      item: jsonMap['item'],
      supermarketSection: jsonMap['supermarketSection'],
      checked: jsonMap['checked'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'item' : item,
      'supermarketSection': supermarketSection,
      'checked': checked,
    };
  }
}