import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:weekly_menu_app/syncronizer/syncro.dart';

import '../models/ingredient.dart';

const String INGREDIENTS_BOX = 'ingredients';

class IngredientsProvider with ChangeNotifier {
  Box<Ingredient> _ingredientsBox = Hive.box(INGREDIENTS_BOX);

  Future<void> fetchIngredients() async {}

  List<Ingredient> get ingredients => _ingredientsBox.values.toList();

  Ingredient getById(Id id) => _ingredientsBox.get(id);

  Future<void> addIngredient(Ingredient ingredient) async {
    await _ingredientsBox.put(ingredient.id.offlineId, ingredient);
    notifyListeners();
  }

  Future<void> deleteIngredient(Ingredient ingredient) async {
    await _ingredientsBox.delete(ingredient.id.offlineId);
    notifyListeners();
  }
}
