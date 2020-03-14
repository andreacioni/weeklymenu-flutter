import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/ingredient.dart';

Ingredient _ingInsalata = Ingredient(
  id: 'iau4dcr',
  name: "Insalata",
);
Ingredient _ingPomodori = Ingredient(
  id: 'nc94nc',
  name: "Pomodori",
);
Ingredient _ingTonno = Ingredient(
  id: 'ks92ej',
  name: "Tonno",
);

List<Ingredient> _ingredients = <Ingredient>[
  _ingInsalata,
  _ingPomodori,
  _ingTonno,
];

class IngredientsProvider with ChangeNotifier {
  List<Ingredient> get getIngredients => [..._ingredients];

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
