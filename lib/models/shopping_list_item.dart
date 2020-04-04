import 'package:flutter/material.dart';

class ShoppingListItem with ChangeNotifier  {
  String item;
  String quantity;
  String unitOfMeasure;
  String supermarketSection;
  bool checked;

  ShoppingListItem({this.item, this.supermarketSection, this.checked});


  factory ShoppingListItem.fromJSON(Map<String, dynamic> jsonMap) {
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