import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:weekly_menu_app/syncronizer/syncro.dart';
import 'package:weekly_menu_app/models/auth_token.dart';
import 'package:weekly_menu_app/datastore/abstract_datastore.dart';

class OnlineDatasource extends AbstractDatastore {
  final _log = Logger();

  static final String BASE_URL =
      'https://heroku-weeklymenu.herokuapp.com/api/v1';

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

  @override
  Future<Map<String, dynamic>> getMenusByDay(String day) async {
    var resp = await _dio.get('$BASE_URL/menus', queryParameters: {'day': day});
    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> createMenu(Map<String, dynamic> menu) async {
    var resp = await _dio.post(
      '$BASE_URL/menus',
      data: menu,
    );

    return resp.data;
  }

  @override
  Future<void> deleteMenu(Id menuId) async {
    assert(menuId.hasValidOnlineId);

    await _dio.delete(
      '$BASE_URL/menus/$menuId',
    );
  }

  @override
  Future<Map<String, dynamic>> getIngredients() async {
    var resp = await _dio.get(
      '$BASE_URL/ingredients',
    );

    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> getShoppingList() async {
    var resp = await _dio.get(
      '$BASE_URL/shopping-lists',
    );

    return resp.data;
  }

  @override
  Future<Map<String, dynamic>> getRecipes() async {
    var resp = await _dio.get(
      '$BASE_URL/recipes',
    );

    return resp.data;
  }

  @override
  Future<void> patchRecipe(Id recipeId, Map<String, dynamic> jsonMap) async {
    assert(recipeId.hasValidOnlineId);

    jsonMap.removeWhere((k, _) => k == '_id');
    var resp = await _dio.patch('$BASE_URL/recipes/$recipeId', data: jsonMap);

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

  @override
  Future<Map<String, dynamic>> patchShoppingList(
      Id shoppingListId, Map<String, dynamic> jsonMap) async {
    assert(shoppingListId.hasValidOnlineId);

    jsonMap.removeWhere((k, _) => k == '_id');
    var resp = await _dio.patch('$BASE_URL/shopping-lists/$shoppingListId',
        data: jsonMap);

    return resp.data;
  }

  @override
  Future<void> deleteIngredient(Id ingredientId) async {
    assert(ingredientId.hasValidOnlineId);

    await _dio.delete('$BASE_URL/ingredients/$ingredientId');
  }

  @override
  Future<Map<String, dynamic>> createRecipe(
      Map<String, dynamic> jsonMap) async {
    jsonMap.removeWhere((k, _) => k == '_id');
    var resp = await _dio.post(
      '$BASE_URL/recipes',
      data: jsonMap,
    );

    return resp.data;
  }

  @override
  Future<void> putMenu(Id menuId, Map<String, dynamic> jsonMap) async {
    assert(menuId.hasValidOnlineId);

    jsonMap.removeWhere((k, _) => k == '_id');
    await _dio.put(
      '$BASE_URL/menus/$menuId',
      data: jsonMap,
    );
  }

  @override
  Future<void> deleteRecipe(Id recipeId) async {
    assert(recipeId.hasValidOnlineId);

    await _dio.delete(
      '$BASE_URL/recipes/$recipeId',
    );
  }

  void _handleErrorResponse(DioError e) {
    if (e.response.statusCode == 401) {
      _log.e("Token is no more valid. Try to login again...");
      //TODO login(email, password);
    }
  }
}
