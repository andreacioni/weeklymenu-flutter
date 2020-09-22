import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weekly_menu_app/datastore/abstract_datastore.dart';

class HiveDatastore implements AbstractDatastore {
  static final String INGREDIENTS_BOX = 'ingredients';
  static final String MENU_BOX = 'menus';
  static final String RECIPES_BOX = 'recipes';
  static final String SHOPLIST_BOX = 'shoplist';

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openLazyBox(INGREDIENTS_BOX);
    await Hive.openLazyBox(MENU_BOX);
    await Hive.openLazyBox(RECIPES_BOX);
    await Hive.openLazyBox(SHOPLIST_BOX);
  }

  @override
  Future<Map<String, dynamic>> createIngredient(
      Map<String, dynamic> ingredient) async {
    ingredient['_id'] = 'temp';
    await Hive.lazyBox(INGREDIENTS_BOX).put(ingrediPent['_id'], ingredient);
    return ingredient;
  }

  @override
  Future<Map<String, dynamic>> createMenu(Map<String, dynamic> menu) {
    // TODO: implement createMenu
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> createRecipe(Map<String, dynamic> jsonMap) {
    // TODO: implement createRecipe
    throw UnimplementedError();
  }

  @override
  Future<void> deleteIngredient(String ingredientId) {
    // TODO: implement deleteIngredient
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMenu(String menuId) {
    // TODO: implement deleteMenu
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRecipe(String recipeId) {
    // TODO: implement deleteRecipe
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getIngredients() {
    // TODO: implement getIngredients
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getMenusByDay(String day) {
    // TODO: implement getMenusByDay
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getRecipes() {
    // TODO: implement getRecipes
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getShoppingList() {
    // TODO: implement getShoppingList
    throw UnimplementedError();
  }

  @override
  Future<void> patchRecipe(String recipeId, Map<String, dynamic> jsonMap) {
    // TODO: implement patchRecipe
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> patchShoppingList(
      String shoppingListId, Map<String, dynamic> jsonMap) {
    // TODO: implement patchShoppingList
    throw UnimplementedError();
  }

  @override
  Future<void> putMenu(String id, Map<String, dynamic> jsonMap) {
    // TODO: implement putMenu
    throw UnimplementedError();
  }

  @override
  Future<void> close() async {
    await Hive.initFlutter();
  }
}
