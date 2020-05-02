import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../datasource/network.dart';
import '../models/ingredient.dart';

class IngredientsProvider with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  List<Ingredient> _ingredients = [];

  List<Ingredient> get getIngredients => [..._ingredients];

  Future<void> fetchIngredients() async {
    //TODO handle pagination
    final jsonPage = await _restApi.getIngredients();
    _ingredients = jsonPage['results']
        .map((jsonMenu) => Ingredient.fromJson(jsonMenu))
        .toList()
        .cast<Ingredient>();
    
    notifyListeners();
  }

  Ingredient getById(String id) =>
      _ingredients.firstWhere((ing) => ing.id == id, orElse: () => null);

  Future<Ingredient> addIngredient(Ingredient ingredient) async {
    var resp = await _restApi.createIngredient(ingredient.toJSON());
    var newIngredient = Ingredient.fromJson(resp);
    
    _ingredients.add(newIngredient);
    notifyListeners();

    return newIngredient;
  }

  Future<void> deleteIngredient(Ingredient ingredient) async {
    _ingredients.removeWhere((ing) => ing.id == ingredient.id);
    notifyListeners();

    _restApi.deleteIngredient(ingredient.id);
  }
}
