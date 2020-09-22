import 'dart:async';

abstract class AbstractDatastore {
  Future<void> init() async {}

  Future<Map<String, dynamic>> getMenusByDay(String day);

  Future<Map<String, dynamic>> createMenu(Map<String, dynamic> menu);

  Future<void> deleteMenu(String menuId);

  Future<Map<String, dynamic>> getIngredients();

  Future<Map<String, dynamic>> getShoppingList();

  Future<Map<String, dynamic>> getRecipes();

  Future<void> patchRecipe(String recipeId, Map<String, dynamic> jsonMap);

  Future<Map<String, dynamic>> createIngredient(
      Map<String, dynamic> ingredient);

  Future<Map<String, dynamic>> patchShoppingList(
      String shoppingListId, Map<String, dynamic> jsonMap);

  Future<void> deleteIngredient(String ingredientId);

  Future<Map<String, dynamic>> createRecipe(Map<String, dynamic> jsonMap);

  Future<void> putMenu(String id, Map<String, dynamic> jsonMap);

  Future<void> deleteRecipe(String recipeId);
}
