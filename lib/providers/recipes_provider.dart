import 'package:flutter/material.dart';
import '../models/ingredient.dart';

import '../datasource/network.dart';
import '../models/recipe.dart';

class RecipesProvider with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  List<Recipe> _recipes = [];

  Future<void> fetchRecipes() async {
    //TODO handle pagination
    final jsonPage = await _restApi.getRecipes();
    _recipes = jsonPage['results']
        .map((jsonMenu) => Recipe.fromJson(jsonMenu))
        .toList()
        .cast<Recipe>();

    notifyListeners();
  }

  List<Recipe> get getRecipes => [..._recipes];

  List<String> get getAllRecipeTags {
    List<String> tags = [];
    _recipes.forEach((recipe) {
      if (recipe.tags != null) {
        tags.addAll(recipe.tags);
      }
    });

    return tags;
  }

  Recipe getById(String id) =>
      _recipes.firstWhere((ing) => ing.id == id, orElse: () => null);
}
