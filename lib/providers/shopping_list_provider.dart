import 'package:flutter/material.dart';

import '../datasource/network.dart';
import '../models/shopping_list.dart';

class ShoppingListProvider with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  ShoppingList _shoppingList = ShoppingList(
    id: '1',
    items: <ShoppingListItem>[
      ShoppingListItem(
        item: '5e761b25189dd19a35cc0ae7',
        checked: false,
        quantity: 200,
      ),
      ShoppingListItem(
          item: '5e761b2d86315b0cfabab843', checked: true, quantity: 10)
    ],
  );

  List<ShoppingListItem> get getCartItems => [..._shoppingList.items];

  Future<void> fetchShoppingListItems() async {
    //TODO handle pagination
    //final jsonPage = await _restApi.getShoppingList();
    //_shoppingList = ShoppingList.fromJSON(jsonPage['results'][0]);

    notifyListeners();
  }

  List<ShoppingListItem> get getShoppingItems => [..._shoppingList.items];

  List<ShoppingListItem> get getCheckedItems =>
      [..._shoppingList.items].where((item) => item.checked).toList();

  List<ShoppingListItem> get getUncheckedItems =>
      [..._shoppingList.items].where((item) => !item.checked).toList();

  ShoppingListItem getById(String itemId) => _shoppingList.items
      .firstWhere((ing) => ing.item == itemId, orElse: () => null);

  Future<ShoppingListItem> addShoppingListItem(
      String shopListId, ShoppingListItem shoppingListItem) async {
    //var resp = await _restApi.createIngredient(shoppingListItem.toJSON());
    //var newShoppingListItem = ShoppingListItem.fromJSON(shopListId, resp);

    //_shoppingList.items.add(newShoppingListItem);
    _shoppingList.items.add(shoppingListItem);
    notifyListeners();

    //return newShoppingListItem;
    return shoppingListItem;
  }
}
