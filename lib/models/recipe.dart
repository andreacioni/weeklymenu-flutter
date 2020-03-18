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

  Recipe(
      {@required this.id,
      this.name,
      this.description,
      this.ingredients = const [],
      this.difficulty,
      this.rating = 0,
      this.cost = 0,
      this.servs = 0,
      this.estimatedPreparationTime = 0,
      this.estimatedCookingTime = 0,
      this.imgUrl,
      this.tags = const []});

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
    if (ingredients == null) {
      ingredients = [recipeIngredient];
    } else {
      ingredients.add(recipeIngredient);
    }
    notifyListeners();
  }

  void deleteRecipeIngredient(String recipeIngredientId) {
    if (ingredients != null && ingredients.isNotEmpty) {
      ingredients.removeWhere((recipeIngredient) =>
          recipeIngredient.ingredientId == recipeIngredientId);
      notifyListeners();
    }
  }

  void addTag(String newTag) {
    if (tags == null) {
      tags = [newTag];
    } else {
      tags.add(newTag);
    }
    notifyListeners();
  }

  void removeTag(String tagToRemove) {
    if (tags != null) {
      tags.removeWhere((tag) => tag == tagToRemove);
      notifyListeners();
    }
  }

  @override
  String toString() => name;
  @override
  bool operator ==(o) => o is Recipe && o.id == this.id;
  @override
  int get hashCode => id.hashCode;
}

class RecipeIngredient with ChangeNotifier {
  String parentRecipeId;
  String ingredientId;
  double quantity;
  String unitOfMeasure;
  bool freezed;
  
  RecipeIngredient({@required this.parentRecipeId, @required this.ingredientId, this.quantity, this.unitOfMeasure, this.freezed});

  @override
  String toString() => parentRecipeId + ingredientId;
  @override
  bool operator ==(o) => o is RecipeIngredient && o.ingredientId == this.ingredientId && o.parentRecipeId == this.parentRecipeId;
  @override
  int get hashCode => parentRecipeId.hashCode^ingredientId.hashCode;
}