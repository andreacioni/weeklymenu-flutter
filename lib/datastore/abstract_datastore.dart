import 'dart:async';

import 'package:weekly_menu_app/syncronizer/syncro.dart';

abstract class AbstractDatastore {
  Future<void> init() async {}

  Future<Map<String, dynamic>> getMenusByDay(String day);

  Future<Map<String, dynamic>> createMenu(Map<String, dynamic> menu);

  Future<void> deleteMenu(Id menuId);

  Future<Map<String, dynamic>> getIngredients();

  Future<Map<String, dynamic>> getShoppingList();

  Future<Map<String, dynamic>> getRecipes();

  Future<void> patchRecipe(Id recipeId, Map<String, dynamic> jsonMap);

  Future<Map<String, dynamic>> createIngredient(
      Map<String, dynamic> ingredient);

  Future<Map<String, dynamic>> patchShoppingList(
      Id shoppingListId, Map<String, dynamic> jsonMap);

  Future<void> deleteIngredient(Id ingredientId);

  Future<Map<String, dynamic>> createRecipe(Map<String, dynamic> jsonMap);

  Future<void> putMenu(Id id, Map<String, dynamic> jsonMap);

  Future<void> deleteRecipe(Id recipeId);
}
