import 'package:dio/dio.dart';

import '../models/recipe.dart';

class NetworkDatasource {
  static final String BASE_URL =
      'https://heroku-weeklymenu.herokuapp.com/api/v1';
  static final String TOKEN =
      'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1ODQ3OTgyNDgsIm5iZiI6MTU4NDc5ODI0OCwianRpIjoiYWQyM2U1ODctODJkZC00YmYyLThiN2EtNDE3YTk4ZDA1NTc0IiwiZXhwIjoyNTg0Nzk5MTQ4LCJpZGVudGl0eSI6ImFuZHJlYWNpb25pIiwiZnJlc2giOmZhbHNlLCJ0eXBlIjoiYWNjZXNzIn0.aoorAJXoC7hfS1CquhaBCR_a9yFuSrdIkeQq8It2Zi8';

  static final BASE_HEADERS = {
    'Authorization': TOKEN,
  };

  static final BASE_PARAMS = {
    'per_page': 1000, //TODO handle pagination
  };

  final Dio _dio = Dio(BaseOptions(
    baseUrl: BASE_URL,
    contentType: 'application/json',
    headers: BASE_HEADERS,
    queryParameters: BASE_PARAMS,
  ));

  static final NetworkDatasource _singleton = new NetworkDatasource._internal();

  factory NetworkDatasource.getInstance() {
    return _singleton;
  }

  NetworkDatasource._internal();

  Future<Map<String, dynamic>> getMenusByDay(String day) async {
    var resp = await _dio.get('$BASE_URL/menus', queryParameters: {'day': day});

    return resp.data;
  }

  Future<List<String>> addRecipeToMenu(String menuId, String recipeId) async {
    var resp = await _dio.post(
      '$BASE_URL/menus/$menuId/recipes',
      data: {'recipe_id': recipeId},
    );

    return resp.data;
  }

  Future<Map<String, dynamic>> createMenu(Map<String, dynamic> menu) async {
    var resp = await _dio.post(
      '$BASE_URL/menus',
      data: menu,
    );

    return resp.data;
  }

  Future<Map<String, dynamic>> getIngredients() async {
    var resp = await _dio.get(
      '$BASE_URL/ingredients',
    );

    return resp.data;
  }

  Future<Map<String, dynamic>> getShoppingList() async {
    var resp = await _dio.get(
      '$BASE_URL/shopping-lists',
    );

    return resp.data;
  }

  Future<Map<String, dynamic>> getRecipes() async {
    var resp = await _dio.get(
      '$BASE_URL/recipes',
    );

    return resp.data;
  }

  Future<void> patchRecipe(
      String recipeId, Map<String, dynamic> jsonMap) async {
    jsonMap.removeWhere((k, _) => k =='_id');
    var resp = await _dio.patch('$BASE_URL/recipes/$recipeId', data: jsonMap);

    return resp.data;
  }

  Future<void> addRecipeIngredient(
      String recipeId, Map<String, dynamic> jsonMap) async {
    var resp;
    try {
      resp = await _dio.post('$BASE_URL/recipes/$recipeId/ingredients',
          data: jsonMap);
    } on DioError catch (e) {
      print(e.response);
      throw e;
    }

    return resp.data;
  }

  Future<void> removeRecipeIngredient(
      String recipeId, String ingredientId) async {
    var resp = await _dio.delete(
      '$BASE_URL/recipes/$recipeId/ingredients/$ingredientId',
    );

    return resp.data;
  }

  Future<Map<String, dynamic>> createIngredient(
      Map<String, dynamic> ingredient) async {
    var resp = await _dio.post(
      '$BASE_URL/ingredients',
      data: ingredient,
    );

    return resp.data;
  }

  Future<void> deleteShoppingItemFromList(
      String shoppingListId, String itemId) async {
    var resp = await _dio
        .delete('$BASE_URL/shopping-lists/$shoppingListId/items/$itemId');

    return resp.data;
  }

  Future<Map<String, dynamic>> addShoppingListItem(
      String shoppingListId, Map<String, dynamic> jsonMap) async {
    var resp = await _dio.post('$BASE_URL/shopping-lists/$shoppingListId/items',
        data: jsonMap);

    return resp.data;
  }

  Future<Map<String, dynamic>> patchShoppingList(
      String shoppingListId, Map<String, dynamic> jsonMap) async {
    var resp = await _dio.patch('$BASE_URL/shopping-lists/$shoppingListId',
        data: jsonMap);

    return resp.data;
  }

  Future<Map<String, dynamic>> patchShoppingListItem(String shoppingListId,
      String itemId, Map<String, dynamic> jsonMap) async {
    var resp = await _dio.patch(
        '$BASE_URL/shopping-lists/$shoppingListId/items/$itemId',
        data: jsonMap);

    return resp.data;
  }

  Future<void> deleteIngredient(String ingredientId) async {
    await _dio.delete('$BASE_URL/ingredients/$ingredientId');
  }

  Future<Map<String, dynamic>> createRecipe(Map<String, dynamic> jsonMap) async {
    jsonMap.removeWhere((k, _) => k =='_id');
    var resp =  await _dio.post(
      '$BASE_URL/recipes',
      data: jsonMap,
    );

    return resp.data;
  }
}
