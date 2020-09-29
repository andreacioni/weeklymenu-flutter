import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/ingredient.dart';

const String INGREDIENTS_BOX = 'ingredients';

class IngredientsProvider with ChangeNotifier {
  Box<Ingredient> _ingredientsBox = Hive.box(INGREDIENTS_BOX);

  List<Ingredient> get ingredients => _ingredientsBox.values.toList();

  Ingredient getById(String id) => _ingredientsBox.get(id);

  Future<void> addIngredient(Ingredient ingredient) async {
    await _ingredientsBox.put(ingredient.id.offlineId, ingredient);
    notifyListeners();
  }

  Future<void> deleteIngredient(Ingredient ingredient) async {
    await _ingredientsBox.delete(ingredient.id.offlineId);
    notifyListeners();
  }
}
