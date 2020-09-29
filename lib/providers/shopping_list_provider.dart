import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:weekly_menu_app/models/ingredient.dart';
import 'package:weekly_menu_app/providers/ingredients_provider.dart';

import '../models/shopping_list.dart';
import 'auth_provider.dart';

const String SHOPLIST_BOX = 'shoplist';

class ShoppingListProvider with ChangeNotifier {
  Box<ShoppingList> _shoppingListBox = Hive.box(SHOPLIST_BOX);

  Future<void> fetchShoppingListItems() async {}

  List<ShoppingList> get shoppingLists => _shoppingListBox.values.toList();

  Future<void> updateShoppingList(ShoppingList shoppingList) async {
    _shoppingListBox.put(shoppingList.id, shoppingList);
  }

  void update(IngredientsProvider ingredientsProvider) {
    List<Ingredient> ingredientsList = ingredientsProvider.ingredients;

    if (ingredientsList != null) {
      for (ShoppingList shoppingList in _shoppingListBox.values) {
        if (shoppingList.items != null) {
          //This is a list but hopefully we expect only one item to be removed
          var toBeRemovedList = shoppingList.items
              .where((item) => (ingredientsList.indexWhere(
                      (ingredient) => ingredient.id == item.ingredientId) ==
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
  }
}
