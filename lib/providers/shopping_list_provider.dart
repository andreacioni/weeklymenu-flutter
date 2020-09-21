import 'package:flutter/material.dart';
import 'package:weekly_menu_app/models/ingredient.dart';
import 'package:weekly_menu_app/providers/ingredients_provider.dart';

import '../models/shopping_list.dart';
import 'rest_provider.dart';

class ShoppingListProvider with ChangeNotifier {
  RestProvider _restProvider;

  List<ShoppingList> _shoppingList = [];

  ShoppingListProvider(this._restProvider);

  Future<void> fetchShoppingListItems() async {
    //TODO handle pagination
    final jsonPage = await _restProvider.getShoppingList();
    _shoppingList = jsonPage['results']
        .map((jsonMenu) => ShoppingList.fromJson(jsonMenu))
        .toList()
        .cast<ShoppingList>();

    notifyListeners();
  }

  List<ShoppingList> get getShoppingLists => [..._shoppingList];

  Future<void> updateShoppingList(ShoppingList shoppingList) async {
    _restProvider.patchShoppingList(shoppingList.id, shoppingList.toJson());
  }

  void update(
      RestProvider restProvider, IngredientsProvider ingredientsProvider) {
    List<Ingredient> ingredientsList = ingredientsProvider.getIngredients;

    if (ingredientsList != null) {
      for (ShoppingList shoppingList in _shoppingList) {
        if (shoppingList.items != null) {
          //This is a list but hopefully we expect only one item to be removed
          var toBeRemovedList = shoppingList.items
              .where((item) => (ingredientsList
                      .indexWhere((ingredient) => ingredient.id == item.item) ==
                  -1))
              .toList();
          bool changed = false;

          for (ShoppingListItem itemToBeRemoved in toBeRemovedList) {
            shoppingList.removeItemFromList(itemToBeRemoved);
            changed = true;
          }

          if (changed) {
            updateShoppingList(shoppingList);
          }
        }
      }
    }

    _restProvider = restProvider;
  }
}
