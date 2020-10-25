import 'package:flutter/material.dart';
import 'package:objectid/objectid.dart';

import 'package:weekly_menu_app/models/ingredient.dart';
import 'package:weekly_menu_app/providers/ingredients_provider.dart';

import '../datasource/network.dart';
import '../models/recipe.dart';
import 'rest_provider.dart';

class RecipesProvider with ChangeNotifier {
  RestProvider _restApi;

  List<RecipeOriginator> _recipes = [];

  RecipesProvider(this._restApi);

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
      if (recipe.tags != null) {
        tags.addAll(recipe.tags);
      }
    });

    return tags;
  }

  RecipeOriginator getById(String id) =>
      _recipes.firstWhere((recipe) => recipe.id == id, orElse: () => null);

  Future<RecipeOriginator> addRecipe(Recipe newRecipe) async {
    assert(newRecipe.id == null);
    newRecipe.id = ObjectId().hexString;

    var recipeJson = await _restApi.createRecipe(newRecipe.toJson());
    var postedRecipe = Recipe.fromJson(recipeJson);

    final RecipeOriginator recipeOriginator = RecipeOriginator(postedRecipe);

    _recipes.add(recipeOriginator);
    notifyListeners();
    return recipeOriginator;
  }

  Future<void> removeRecipe(RecipeOriginator recipe) async {
    await _restApi.deleteRecipe(recipe.id);
    _recipes.removeWhere((rec) => rec.id == recipe.id);
    notifyListeners();
  }

  Future<void> saveRecipe(RecipeOriginator recipe) async {
    assert(recipe.id != null);
    try {
      await _restApi.patchRecipe(recipe.id, recipe.toJson());
      recipe.save();
    } catch (e) {
      recipe.revert();
      throw e;
    }
    notifyListeners();
  }

  void update(
      RestProvider restProvider, IngredientsProvider ingredientsProvider) {
    List<Ingredient> ingredientsList = ingredientsProvider.getIngredients;
    if (ingredientsList != null) {
      for (RecipeOriginator recipe in _recipes) {
        if (recipe.ingredients != null) {
          //This is a list but hopefully we expect only one item to be removed
          var toBeRemovedList = recipe.ingredients
              .where((recipeIngredient) => (ingredientsList.indexWhere(
                      (ingredient) =>
                          ingredient.id == recipeIngredient.ingredientId) ==
                  -1))
              .toList();

          for (RecipeIngredient recipeIngredientToBeRemvoved
              in toBeRemovedList) {
            recipe.deleteRecipeIngredient(
                recipeIngredientToBeRemvoved.ingredientId);
          }
        }
      }
    }

    _restApi = restProvider;
  }
}
