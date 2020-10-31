import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:weekly_menu_app/models/ingredient.dart';
import 'package:weekly_menu_app/models/shopping_list.dart';
import 'package:weekly_menu_app/providers/ingredients_provider.dart';

import 'rest_provider.dart';

class ShoppingListProvider with ChangeNotifier {
  final _log = Logger();

  Box<ShoppingList> _box;

  RestProvider _restProvider;

  ShoppingListProvider(this._restProvider);

  Future<void> fetchShoppingListItems() async {
    _box = await Hive.openBox("shopping-lists");
    notifyListeners();
  }

  List<ShoppingList> get shoppingLists => _box.values.toList();

  Future<void> updateShoppingList(ShoppingList shoppingList) async {
    _box.put(shoppingList.id, shoppingList);
  }

  void update(
      RestProvider restProvider, IngredientsProvider ingredientsProvider) {
    List<Ingredient> ingredientsList = ingredientsProvider.ingredients;

    if (ingredientsList != null) {
      for (ShoppingList shoppingList in shoppingLists) {
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
