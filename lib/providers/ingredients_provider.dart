import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../models/unit_of_measure.dart';

  RecipeIngredient _ingInsalata = RecipeIngredient(
      id: 'iau4dcr',
      name: "Insalata",
      quantity: 50,
      unitOfMeasure: unitsOfMeasure[0]);
  RecipeIngredient _ingPomodori = RecipeIngredient(
      id: 'nc94nc',
      name: "Pomodori",
      quantity: 1,
      unitOfMeasure: unitsOfMeasure[0]);
  RecipeIngredient _ingTonno = RecipeIngredient(
      id: 'ks92ej',
      name: "Tonno",
      quantity: 50,
      unitOfMeasure: unitsOfMeasure[2]);

  List<Ingredient> _ingredients = <Ingredient>[
    _ingInsalata,
    _ingPomodori,
    _ingTonno,
  ];

class IngredientsProvider with ChangeNotifier {

  List<Ingredient> get getIngredients => [..._ingredients];

  Ingredient getById(String id) =>
      _ingredients.firstWhere((ing) => ing.id == id);
}
