import 'package:flutter/foundation.dart';

import './ingredient.dart';

class Recipe with ChangeNotifier {
  String id;
  
  String name;
  String description;
  int rating;
  int cost;
  String difficulty;
  List<int> availabilityMonths;
  
  int servs;
  int estimatedCookingTime;
  int estimatedPreparationTime;

  List<RecipeIngredient> ingredients;

  String preparation;
  String note;
  
  String imgUrl;
  String recipeUrl;
  List<String> tags;

  String owner;

  Recipe({@required this.id, this.name, this.description, this.ingredients = const [], this.difficulty, this.rating = 0, this.cost = 0, this.servs = 0, this.estimatedPreparationTime = 0, this.estimatedCookingTime = 0, this.imgUrl, this.tags = const []});

  void updateDifficulty(String id, String difficulty) {
    this.difficulty = difficulty;
    notifyListeners();
  }

  void updateServs(int servs) {
    this.servs = servs;
    notifyListeners();
  }

  void updatePreparationTime(int estimatedPreparationTime) {
    this.estimatedPreparationTime = estimatedPreparationTime;
    notifyListeners();
  }

  void updateCookingTime(int estimatedCookingTime) {
    this.estimatedCookingTime = estimatedCookingTime;
    notifyListeners();
  }

  void addRecipeIngredient(RecipeIngredient recipeIngredient) {
    if(ingredients == null) {
      ingredients = [recipeIngredient];
    } else {
      ingredients.add(recipeIngredient);
    }
      notifyListeners();
  }
  
  void deleteRecipeIngredient(String recipeIngredientId) {
    if(ingredients != null && ingredients.isNotEmpty) {
      ingredients.removeWhere((recipeIngredient) => recipeIngredient.ingredientId == recipeIngredientId);
      notifyListeners();
    }
  }

  @override
  String toString() => name;
  @override
  bool operator == (o) => o is Recipe && o.id == this.id;
  @override
  int get hashCode => id.hashCode;
}

