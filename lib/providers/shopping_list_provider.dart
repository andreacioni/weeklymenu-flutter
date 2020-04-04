import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../datasource/network.dart';
import '../models/shopping_list_item.dart';

class ShoppingListProvider with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  List<ShoppingListItem> _shoppingListItems = [];

  List<ShoppingListItem> get getCartItems => [..._shoppingListItems];

  Future<void> fetchShoppingListItems() async {
    //TODO handle pagination
    final jsonPage = await _restApi.getIngredients();
    _shoppingListItems = jsonPage['results']
        .map((jsonMenu) => ShoppingListItem.fromJSON(jsonMenu))
        .toList()
        .cast<ShoppingListItem>();

        notifyListeners();
  }

  List<ShoppingListItem> get getShoppingItems => [..._shoppingListItems];

  ShoppingListItem getById(String itemId) =>
      _shoppingListItems.firstWhere((ing) => ing.item == itemId, orElse: () => null);

  Future<ShoppingListItem> addIngredient(ShoppingListItem shoppingListItem) async {
    var resp = await _restApi.createIngredient(shoppingListItem.toJSON());
    var newShoppingListItem = ShoppingListItem.fromJSON(resp);
    
    _shoppingListItems.add(newShoppingListItem);
    notifyListeners();

    return newShoppingListItem;
  }
}
