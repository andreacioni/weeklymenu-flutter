import 'dart:convert';

import 'package:flutter/foundation.dart';

import './ingredient.dart';
import '../datasource/network.dart';

class Recipe with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

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
      this.ingredients,
      this.difficulty,
      this.rating = 0,
      this.cost = 0,
      this.servs = 0,
      this.estimatedPreparationTime = 0,
      this.estimatedCookingTime = 0,
      this.imgUrl,
      this.tags}) {
    this.ingredients = [];
    this.tags = [];
  }

  factory Recipe.fromJSON(Map<String, dynamic> jsonMap) {
    return Recipe(
      id: jsonMap['_id'],
      name: jsonMap['name'],
      description: jsonMap['description'],
      servs: jsonMap['servs'],
      rating: jsonMap['rating'],
      cost: jsonMap['cost'],
      difficulty: jsonMap['difficulty'],
      estimatedCookingTime: jsonMap['estimatedCookingTime'],
      estimatedPreparationTime: jsonMap['estimatedPreparationTime'],
      ingredients: jsonMap['ingredients'] != null ? jsonMap['ingredients'].map((recipeIngredientMap) => RecipeIngredient.fromJSON(recipeIngredientMap)).toList() : []
    );
  }

  void updateDifficulty(String newValue) {
    final oldValue = difficulty;
    difficulty = newValue;
    notifyListeners();

    try {
      _restApi.patchRecipe(id, {'difficulty': newValue});
    } catch (error) {
      difficulty = oldValue;
      notifyListeners();
    }
  }

  void updatePreparationTime(int newValue) {
    final oldValue = estimatedPreparationTime;
    estimatedPreparationTime = newValue;
    notifyListeners();

    try {
      _restApi.patchRecipe(id, {'estimatedCookingTime': newValue});
    } catch (error) {
      estimatedPreparationTime = oldValue;
      notifyListeners();
    }
  }

  void updateCookingTime(int newValue) {
    final oldValue = estimatedCookingTime;
    estimatedCookingTime = newValue;
    notifyListeners();

    try {
      _restApi.patchRecipe(id, {'estimatedCookingTime': newValue});
    } catch (error) {
      estimatedCookingTime = oldValue;
      notifyListeners();
    }
  }

  void updateRating(int newValue) {
    final oldValue = rating;
    rating = newValue;
    notifyListeners();

    try {
      _restApi.patchRecipe(id, {'rating': newValue});
    } catch (error) {
      rating = oldValue;
      notifyListeners();
    }
  }

  void updateCost(int newValue) {
    final oldValue = cost;
    cost = newValue;
    notifyListeners();

    try {
      _restApi.patchRecipe(id, {'cost': newValue});
    } catch (error) {
      cost = oldValue;
      notifyListeners();
    }
  }

  void addRecipeIngredient(RecipeIngredient recipeIngredient) {
    final oldValue = ingredients;

    if (ingredients == null) {
      ingredients = [recipeIngredient];
    } else {
      ingredients.add(recipeIngredient);
    }
    notifyListeners();

    try {
      _restApi.addRecipeIngredient(id, recipeIngredient.toJSON());
    } catch (error) {
      ingredients = oldValue;
      notifyListeners();
    }
  }

  void deleteRecipeIngredient(String recipeIngredientId) {
    if (ingredients != null && ingredients.isNotEmpty) {
      ingredients.removeWhere((recipeIngredient) =>
          recipeIngredient.ingredientId == recipeIngredientId);
      notifyListeners();
    }
  }

  void addTag(String newTag) {
    final oldValue = tags;
    if (tags == null) {
      tags = [newTag];
    } else {
      tags.add(newTag);
    }
    notifyListeners();

    try {
      _restApi.patchRecipe(id, {'tags': tags});
    } catch (error) {
      tags = oldValue;
      notifyListeners();
    }
  }

  void removeTag(String tagToRemove) {
    final oldValue = tags;
    if (tags != null) {
      tags.removeWhere((tag) => tag == tagToRemove);
      notifyListeners();
    }

    try {
      _restApi.patchRecipe(id, {'tags': tags});
    } catch (error) {
      tags = oldValue;
      notifyListeners();
    }
  }

  void updateDescription(String newValue) {
    final oldValue = description;
    description = newValue;
    notifyListeners();

    try {
      _restApi.patchRecipe(id, {'description': newValue});
    } catch (error) {
      description = oldValue;
      notifyListeners();
    }
  }

  void updateServs(int newValue) {
    final oldValue = servs;
    servs = newValue;
    notifyListeners();

    try {
      _restApi.patchRecipe(id, {'servs': newValue});
    } catch (error) {
      servs = oldValue;
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
  String ingredientId;
  double quantity;
  String unitOfMeasure;
  bool freezed;

  RecipeIngredient(
      {@required this.ingredientId,
      this.quantity = 0,
      this.unitOfMeasure,
      this.freezed = false});

  factory RecipeIngredient.fromJSON(Map<String, dynamic> jsonMap) {
    return RecipeIngredient(
      ingredientId: jsonMap['ingredient'],
      quantity: jsonMap['quantity'],
      unitOfMeasure: jsonMap['unitOfMeasure'],
      freezed: jsonMap['freezed'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'quantity': quantity,
      'unitOfMeasure': unitOfMeasure,
      'ingredient': ingredientId,
      'freezed': freezed,
    };
  }

  @override
  bool operator ==(o) =>
      o is RecipeIngredient && o.ingredientId == this.ingredientId;
  @override
  int get hashCode => ingredientId.hashCode;
}
