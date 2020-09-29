import 'dart:isolate';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:weekly_menu_app/datastore/abstract_datastore.dart';
import 'package:weekly_menu_app/syncronizer/syncro.dart';

class HiveDatastore implements AbstractDatastore {
  static final String INGREDIENTS_BOX = 'ingredients';
  static final String MENU_BOX = 'menus';
  static final String RECIPES_BOX = 'recipes';
  static final String SHOPLIST_BOX = 'shoplist';

  ReceivePort _receivePort;
  SendPort _sendPort;
  Isolate _syncIsolate;

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openLazyBox(INGREDIENTS_BOX);
    await Hive.openLazyBox(MENU_BOX);
    await Hive.openLazyBox(RECIPES_BOX);
    await Hive.openLazyBox(SHOPLIST_BOX);

    _receivePort = ReceivePort();
    _syncIsolate = await Isolate.spawn(
        _syncronizationIsolateCallback, _receivePort.sendPort);
    _sendPort = await _receivePort.first;
  }

  @override
  Future<Map<String, dynamic>> createIngredient(
      Map<String, dynamic> ingredient) async {
    ingredient['_id'] = Uuid().v4();
    await Hive.lazyBox(INGREDIENTS_BOX).put(ingredient['_id'], ingredient);
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
  Future<void> deleteIngredient(Id ingredientId) {
    // TODO: implement deleteIngredient
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMenu(Id menuId) {
    // TODO: implement deleteMenu
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRecipe(Id recipeId) {
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
  Future<void> patchRecipe(Id recipeId, Map<String, dynamic> jsonMap) {
    // TODO: implement patchRecipe
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> patchShoppingList(
      Id shoppingListId, Map<String, dynamic> jsonMap) {
    // TODO: implement patchShoppingList
    throw UnimplementedError();
  }

  @override
  Future<void> putMenu(Id id, Map<String, dynamic> jsonMap) {
    // TODO: implement putMenu
    throw UnimplementedError();
  }

  @override
  Future<void> close() async {
    _syncIsolate?.kill(priority: Isolate.immediate);
    _syncIsolate = null;

    await Hive.close();
  }

  static void _syncronizationIsolateCallback(SendPort callerSendPort) async {
    ReceivePort receivePort = ReceivePort();

    callerSendPort.send(receivePort.sendPort);

    await for (var message in receivePort) {}
  }
}

@HiveType(typeId: 1)
class _HiveObjectWrapper {
  @HiveField(0)
  final String offlineId;

  @HiveField(1)
  final String onlineId;

  @HiveField(2)
  final _HiveObjectState state;

  @HiveField(3)
  final Map<String, Object> element;

  _HiveObjectWrapper(this.offlineId, this.onlineId, this.state, this.element);
}

@HiveType(typeId: 2)
enum _HiveObjectState {
  @HiveField(0)
  CREATED,
  @HiveField(1)
  AVAILABLE,
  @HiveField(2)
  DELETED
}
