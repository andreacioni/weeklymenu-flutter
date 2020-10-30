import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:objectid/objectid.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:weekly_menu_app/providers/rest_provider.dart';

import '../models/ingredient.dart';

class IngredientsProvider with ChangeNotifier {
  final _log = Logger();

  Database _db;
  StoreRef<int, Map<String, dynamic>> _store;

  //TOOD remove this
  var _restProvider;

  IngredientsProvider(this._restProvider);

  Future<void> fetchIngredients() async {
    _db = await databaseFactoryIo.openDatabase("ingredients.db");
    _store = intMapStoreFactory.store("ingredients");
    notifyListeners();
  }

  List<Ingredient> get ingredients => _store
      .stream(_db)
      .asyncMap((event) => Ingredient.fromJson(event.value))
      .toList();

  Future<Ingredient> getById(String id) async {
    final snapshot = await _store.findFirst(
      _db,
      finder: Finder(filter: Filter.equals("id", id)),
    );

    return Ingredient.fromJson(snapshot.value);
  }

  Future<Ingredient> addIngredient(Ingredient ingredient) async {
    assert(ingredient.id == null);
    ingredient.id = ObjectId().hexString;

    await _store.add(_db, ingredient.toJson());

    notifyListeners();
    return ingredient;
  }

  Future<void> deleteIngredient(Ingredient ingredient) async {
    await _store.delete(_db, finder: Finder(filter: Filter.byKey(key)));
    notifyListeners();
  }

  void update(RestProvider restProvider) {
    _restProvider = restProvider;
  }
}
