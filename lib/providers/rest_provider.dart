import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:weekly_menu_app/models/auth_token.dart';

class RestProvider with ChangeNotifier {
  final _log = Logger();

  static final String BASE_URL = 'http://10.0.2.2:5000/api/v1';

  static final BASE_HEADERS = <String, dynamic>{};

  static final BASE_PARAMS = {
    'per_page': 1000, //TODO handle pagination
  };

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      contentType: 'application/json',
      headers: BASE_HEADERS,
      queryParameters: BASE_PARAMS,
    ),
  );

  Timer _expiryTokenTimer;

  String email, password;

  RestProvider() {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (e) {
        switch (e.type) {
          case DioErrorType.RESPONSE:
            _handleErrorResponse(e);
            break;
          case DioErrorType.CONNECT_TIMEOUT:
          case DioErrorType.SEND_TIMEOUT:
          case DioErrorType.RECEIVE_TIMEOUT:
          case DioErrorType.CANCEL:
          case DioErrorType.DEFAULT:
            break;
        }
      },
    ));
  }

  Future<Map<String, dynamic>> getMenusByDay(String day) async {
    var resp = await _dio.get('$BASE_URL/menus', queryParameters: {'day': day});
    return resp.data;
  }

  Future<void> addRecipeToMenu(String menuId, String recipeId) async {
    await _dio.post(
      '$BASE_URL/menus/$menuId/recipes',
      data: {'recipe_id': recipeId},
    );
  }

  Future<Map<String, dynamic>> createMenu(Map<String, dynamic> menu) async {
    var resp = await _dio.post(
      '$BASE_URL/menus',
      data: menu,
    );

    return resp.data;
  }

  Future<void> deleteMenu(String menuId) async {
    await _dio.delete(
      '$BASE_URL/menus/$menuId',
    );
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
    jsonMap.removeWhere((k, _) => k == '_id');
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
    jsonMap.removeWhere((k, _) => k == '_id');
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

  Future<Map<String, dynamic>> createRecipe(
      Map<String, dynamic> jsonMap) async {
    jsonMap.removeWhere((k, _) => k == '_id');
    var resp = await _dio.post(
      '$BASE_URL/recipes',
      data: jsonMap,
    );

    return resp.data;
  }

  Future<void> putMenu(String id, Map<String, dynamic> jsonMap) async {
    jsonMap.removeWhere((k, _) => k == '_id');
    await _dio.put(
      '$BASE_URL/menus/$id',
      data: jsonMap,
    );
  }

  Future<void> deleteRecipe(String recipeId) async {
    await _dio.delete(
      '$BASE_URL/recipes/$recipeId',
    );
  }

  Future<void> register(String name, email, password) async {
    var resp = await _dio.post('$BASE_URL/auth/register',
        data: {'name': name, 'email': email, 'password': password});

    return resp.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    var resp = await _dio.post('$BASE_URL/auth/token',
        data: {'email': email, 'password': password});

    this.email = email;
    this.password = password;

    return resp.data;
  }

  Future<void> logout() async {
    await _dio.post('$BASE_URL/auth/logout');
    _clearToken();
  }

  Future<void> resetPassword(String email) async {
    await _dio.post('$BASE_URL/auth/reset_password', data: {'email': email});
  }

  Future<void> updateToken(JWTToken jwt) async {
    _cancelTimer();

    _expiryTokenTimer = Timer(jwt.duration, () {
      _clearToken();
    });

    _dio.options.headers['Authorization'] = "Bearer ${jwt.toJwtString}";
  }

  void _clearToken() {
    _dio.options.headers['Authorization'] = '';
    _cancelTimer();
  }

  void _cancelTimer() {
    if (_expiryTokenTimer != null) {
      _expiryTokenTimer.cancel();
      _expiryTokenTimer = null;
    }
  }

  void _handleErrorResponse(DioError e) {
    if (e.response.statusCode == 401) {
      _log.e("Token is no more valid. Try to login again...");
      //TODO login(email, password);
    }
  }
}
