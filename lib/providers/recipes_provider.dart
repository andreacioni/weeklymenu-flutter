import 'package:flutter/material.dart';
import '../models/ingredient.dart';

import '../models/recipe.dart';

Recipe _insalataAndrea = Recipe(
  id: "adfie82bfiui",
  name: "Insalata Andrea",
  description: "A delicious salad",
  servs: 2,
  rating: 2,
  cost: 1,
  estimatedCookingTime: 0,
  estimatedPreparationTime: 10,
  ingredients: [
    RecipeIngredient(ingredientId: "ks92ej", quantity: 2, unitOfMeasure: "pcs"),
    RecipeIngredient(ingredientId: "nc94nc", quantity: 1, unitOfMeasure: "L"),
    RecipeIngredient(ingredientId: "iau4dcr", quantity: 200, unitOfMeasure: "gr"),
  ],
  imgUrl:
      "https://www.cucchiaio.it/content/cucchiaio/it/ricette/2018/08/insalata-con-uova-pane-e-mandorle/jcr:content/header-par/image-single.img10.jpg/1533489383063.jpg",
  tags: ["Vegetarian", "Healty", "Fast"],
);

Recipe _paneeOlio = Recipe(
  id: "fno2ecb22o",
  name: "Pane & Olio",
);

Recipe _vellutataDiCeci = Recipe(
  id: "314rf42e",
  name: "Vellutata di ceci",
);

Recipe _pizza = Recipe(
  id: "24w1r1d13",
  name: "Pizza",
);
Recipe _pizzaCottoEFunghi = Recipe(
  id: "o108vh80924",
  name: "Pizza Cotto & Funghi",
);

class RecipesProvider with ChangeNotifier {
  List<Recipe> _recipes = [_insalataAndrea, _paneeOlio];

  List<Recipe> get getRecipes => [..._recipes];

  Recipe getById(String id) => _recipes.firstWhere((ing) => ing.id == id, orElse: () => null);

  void updateDifficulty(String id, String difficulty) {
    Recipe recipe = getById(id);

    if(recipe != null) {
      recipe.difficulty = difficulty;
      notifyListeners();
    }
  }

  void updateServs(String id, int servs) {
    Recipe recipe = getById(id);

    if(recipe != null) {
      recipe.servs = servs;
      notifyListeners();
    }
  }
  
  void updatePreparationTime(String id, int estimatedPreparationTime) {
    Recipe recipe = getById(id);

    if(recipe != null) {
      recipe.estimatedPreparationTime = estimatedPreparationTime;
      notifyListeners();
    }
  }

  void updateCookingTime(String id, int estimatedCookingTime) {
    Recipe recipe = getById(id);

    if(recipe != null) {
      recipe.estimatedCookingTime = estimatedCookingTime;
      notifyListeners();
    }
  }

  void addRecipeIngredient(String id, RecipeIngredient recipeIngredient) {
    Recipe recipe = getById(id);

    if(recipe != null) {
      if(recipe.ingredients == null) {
        recipe.ingredients = [recipeIngredient];
      } else {
        recipe.ingredients.add(recipeIngredient);
      }
      notifyListeners();
    }
  }
  
  void deleteRecipeIngredient(String id, String recipeIngredientId) {
    Recipe recipe = _recipes.firstWhere((recipe) => recipe.id == id, orElse: () => null);
    if(recipe != null && recipe.ingredients != null) {
      recipe.ingredients.removeWhere((recipeIngredient) => recipeIngredient.ingredientId == recipeIngredientId);
      notifyListeners();
    }
  }
}
