import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:weekly_menu_app/providers/rest_provider.dart';

import '../models/ingredient.dart';

class IngredientsProvider with ChangeNotifier {
  RestProvider _restProvider;

  List<Ingredient> _ingredients = [];

  List<Ingredient> get getIngredients => [..._ingredients];

  IngredientsProvider(this._restProvider);

  Future<void> fetchIngredients() async {
    //TODO handle pagination
    final jsonPage = await _restProvider.getIngredients();
    _ingredients = jsonPage['results']
        .map((jsonMenu) => Ingredient.fromJson(jsonMenu))
        .toList()
        .cast<Ingredient>();

    notifyListeners();
  }

  Ingredient getById(String id) =>
      _ingredients.firstWhere((ing) => ing.id == id, orElse: () => null);

  Future<Ingredient> addIngredient(Ingredient ingredient) async {
    var resp = await _restProvider.createIngredient(ingredient.toJSON());
    var newIngredient = Ingredient.fromJson(resp);

    _ingredients.add(newIngredient);
    notifyListeners();

    return newIngredient;
  }

  Future<void> deleteIngredient(Ingredient ingredient) async {
    _ingredients.removeWhere((ing) => ing.id == ingredient.id);
    notifyListeners();

    _restProvider.deleteIngredient(ingredient.id);
  }

  void update(RestProvider restProvider) {
    _restProvider = restProvider;
  }
}
