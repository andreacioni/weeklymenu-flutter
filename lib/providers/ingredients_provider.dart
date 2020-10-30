import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:objectid/objectid.dart';
import 'package:uuid/uuid.dart';
import 'package:weekly_menu_app/providers/rest_provider.dart';

import '../models/ingredient.dart';

class IngredientsProvider with ChangeNotifier {
  final _log = Logger();

  Box<Ingredient> _box;

  //TOOD remove this
  var _restProvider;

  IngredientsProvider(this._restProvider);

  Future<void> fetchIngredients() async {
    _box = await Hive.openBox<Ingredient>("ingredients");
    notifyListeners();
  }

  List<Ingredient> get ingredients => _box.values.toList();

  Ingredient getById(String id) => _box.get(id);

  Future<Ingredient> addIngredient(Ingredient ingredient) async {
    assert(ingredient.id == null);

    await _box.add(ingredient);

    notifyListeners();
    return ingredient;
  }

  Future<void> deleteIngredient(Ingredient ingredient) async {
    _box.delete(ingredient.id);
    notifyListeners();
  }

  void update(RestProvider restProvider) {
    _restProvider = restProvider;
  }
}
