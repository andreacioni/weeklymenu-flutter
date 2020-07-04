import 'package:flutter/material.dart';
import 'package:weekly_menu_app/models/ingredient.dart';
import 'package:weekly_menu_app/providers/ingredients_provider.dart';

import '../datasource/network.dart';
import '../models/shopping_list.dart';

class ShoppingListProvider with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  List<ShoppingList> _shoppingList = [];


  Future<void> fetchShoppingListItems() async {
    //TODO handle pagination
    final jsonPage = await _restApi.getShoppingList();
    _shoppingList = jsonPage['results']
        .map((jsonMenu) => ShoppingList.fromJson(jsonMenu))
        .toList()
        .cast<ShoppingList>();

    notifyListeners();
  }

  List<ShoppingList> get getShoppingLists => [..._shoppingList]; 

  void update(IngredientsProvider ingredientsProvider) {
    List<Ingredient> ingredientsList = ingredientsProvider.getIngredients;

    if(ingredientsList != null) {
      for (ShoppingList shoppingList in _shoppingList) {
        if(shoppingList.items != null) {
          //This is a list but hopefully we expect only one item to be removed
          var toBeRemovedList = shoppingList.items.where((item) =>  (ingredientsList.indexWhere((ingredient) => ingredient.id == item.item) == -1)).toList();
          
          for(ShoppingListItem itemToBeRemoved in toBeRemovedList) {
            shoppingList.removeItemFromList(itemToBeRemoved);
          }
        }
      }
    }
    
  }
}
