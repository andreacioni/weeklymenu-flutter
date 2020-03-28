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

  bool _edited = false;

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
      this.tags});

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
        ingredients: jsonMap['ingredients'] != null
            ? jsonMap['ingredients']
                .map((recipeIngredientMap) => RecipeIngredient.fromJSON(
                    jsonMap['_id'], recipeIngredientMap))
                .toList()
                .cast<RecipeIngredient>()
            : [],
        tags: jsonMap['tags'] != null ? jsonMap['tags'].cast<String>() : []);
  }

  Map<String, dynamic> toJSON() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'servs': servs,
      'rating': rating,
      'cost': cost,
      'difficulty': difficulty,
      'estimatedCookingTime': estimatedCookingTime,
      'estimatedPreparationTime': estimatedPreparationTime,
      'ingredients': ingredients != null
          ? ingredients
              .map((recipeIngredient) => recipeIngredient.toJSON())
              .toList()
          : [],
      'tags': tags
    };
  }

  void updateDifficulty(String newValue) {
    _edited = true;
    difficulty = newValue;
    notifyListeners();
  }

  void updatePreparationTime(int newValue) {
    _edited = true;
    estimatedPreparationTime = newValue;
    notifyListeners();
  }

  void updateCookingTime(int newValue) {
    _edited = true;
    estimatedCookingTime = newValue;
    notifyListeners();
  }

  void updateRating(int newValue) {
    _edited = true;
    rating = newValue;
    notifyListeners();
  }

  void updateCost(int newValue) {
    _edited = true;
    cost = newValue;
    notifyListeners();
  }

  void addRecipeIngredient(RecipeIngredient recipeIngredient) {
    _edited = true;
    if (ingredients == null) {
      ingredients = [recipeIngredient];
    } else {
      ingredients.add(recipeIngredient);
    }
    notifyListeners();
  }

  void deleteRecipeIngredient(String recipeIngredientId) {
    if (ingredients != null && ingredients.isNotEmpty) {
      _edited = true;
      ingredients.removeWhere((recipeIngredient) =>
          recipeIngredient.ingredientId == recipeIngredientId);
      notifyListeners();
    }
  }

  void addTag(String newTag) {
    _edited = true;
    if (tags == null) {
      tags = [newTag];
    } else {
      tags.add(newTag);
    }
    notifyListeners();
  }

  void removeTag(String tagToRemove) {
    _edited = true;
    if (tags != null) {
      tags.removeWhere((tag) => tag == tagToRemove);
      notifyListeners();
    }
  }

  void updateDescription(String newValue) {
    _edited = true;
    description = newValue;
    notifyListeners();
  }

  void updateImgUrl(String newValue) {
    _edited = true;
    imgUrl = newValue;
    notifyListeners();
  }

  void updatePreparation(String newValue) {
    _edited = true;
    preparation = newValue;
    notifyListeners();
  }

  void updateNote(String newValue) {
    _edited = true;
    note = newValue;
    notifyListeners();
  }

  void updateServs(int newValue) {
    _edited = true;
    servs = newValue;
    notifyListeners();
  }

  bool get isResourceEdited => _edited;

  Future<void> save() async {
    await _restApi.patchRecipe(id, this.toJSON());
    _edited = false;
    ingredients.forEach((recipeIngredient) => recipeIngredient.save());
  }

  @override
  String toString() => name;
  @override
  bool operator ==(o) => o is Recipe && o.id == this.id;
  @override
  int get hashCode => id.hashCode;
}

class RecipeIngredient with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  String recipeId;
  String ingredientId;
  double quantity;
  String unitOfMeasure;
  bool freezed;

  bool _edited = false;

  RecipeIngredient(
      {@required this.recipeId,
      @required this.ingredientId,
      this.quantity = 0,
      this.unitOfMeasure,
      this.freezed = false})
      : assert(recipeId != null) {
    if (quantity == null) {
      this.quantity = 0;
    }

    if (freezed == null) {
      this.freezed = false;
    }
  }

  factory RecipeIngredient.fromJSON(
      String recId, Map<String, dynamic> jsonMap) {
    return RecipeIngredient(
      recipeId: recId,
      ingredientId: jsonMap['ingredient'],
      quantity: jsonMap['quantity'],
      unitOfMeasure: jsonMap['unitOfMeasure'],
      freezed: jsonMap['freezed'],
    );
  }

  Map<String, dynamic> toJSON() {
    final jsonMap = {
      'quantity': quantity,
      'unitOfMeasure': unitOfMeasure,
      'ingredient': ingredientId,
      'freezed': freezed,
    };

    jsonMap.removeWhere((_, v) => v == null);

    return jsonMap;
  }

  void setQuantity(double newValue) {
    _edited = true;
    quantity = newValue;
    notifyListeners();
  }

  void setUom(String newValue) {
    _edited = true;
    unitOfMeasure = newValue;
    notifyListeners();
  }

  void setFreezed(bool newValue) {
    _edited = true;
    freezed = newValue;
    notifyListeners();
  }

  bool get isResourceEdited => _edited;

  Future<void> save() {
    //No patch here (this is done by the recipe class)
    _edited = false;
    return Future.delayed(Duration.zero);
  }

  @override
  bool operator ==(o) =>
      o is RecipeIngredient && o.ingredientId == this.ingredientId;
  @override
  int get hashCode => ingredientId.hashCode;
}
