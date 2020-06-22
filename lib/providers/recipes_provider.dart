import 'package:flutter/material.dart';

import '../datasource/network.dart';
import '../models/recipe.dart';

class RecipesProvider with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  List<RecipeOriginator> _recipes = [];

  Future<void> fetchRecipes() async {
    //TODO handle pagination
    final jsonPage = await _restApi.getRecipes();
    _recipes = jsonPage['results']
        .map((jsonMenu) => RecipeOriginator(Recipe.fromJson(jsonMenu)))
        .toList()
        .cast<RecipeOriginator>();

    notifyListeners();
  }

  List<RecipeOriginator> get getRecipes => [..._recipes];

  List<String> get getAllRecipeTags {
    List<String> tags = [];
    _recipes.forEach((recipe) {
      if (recipe.instance.tags != null) {
        tags.addAll(recipe.instance.tags);
      }
    });

    return tags;
  }

  RecipeOriginator getById(String id) => _recipes
      .firstWhere((recipe) => recipe.instance.id == id, orElse: () => null);

  Future<RecipeOriginator> addRecipe(Recipe newRecipe) async {
    assert(newRecipe.id == null);
    
    var recipeJson = await _restApi.createRecipe(newRecipe.toJson());
    var postedRecipe = Recipe.fromJson(recipeJson);
    
    final RecipeOriginator recipeOriginator = RecipeOriginator(postedRecipe);
    
    _recipes.add(recipeOriginator);
    notifyListeners();
    return recipeOriginator;
  }
}
