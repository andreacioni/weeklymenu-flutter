import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../datasource/network.dart';
import '../models/ingredient.dart';

class IngredientsProvider with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource();

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

  Ingredient addIngredient(Ingredient ingredient) {
    if (ingredient.id == null || ingredient.id == 'NONE') {
      ingredient.id = Uuid().v4();
    }

    _ingredients.add(ingredient);
    notifyListeners();
  }
}
