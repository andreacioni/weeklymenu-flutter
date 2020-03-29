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
        .map((jsonMenu) => Ingredient.fromJSON(jsonMenu))
        .toList()
        .cast<Ingredient>();
  }

  Ingredient getById(String id) =>
      _ingredients.firstWhere((ing) => ing.id == id, orElse: () => null);

  Future<Ingredient> addIngredient(Ingredient ingredient) async {
    var resp = await _restApi.createIngredient(ingredient.toJSON());
    var newIngredient = Ingredient.fromJSON(resp);
    
    _ingredients.add(newIngredient);
    notifyListeners();

    return newIngredient;
  }
}
