import 'package:flutter/foundation.dart';

class RecipeIngredient {
  String ingredientId;
  double quantity;
  String unitOfMeasure;
  bool freezed;

  RecipeIngredient({@required recipeIngredient, name, this.quantity, this.unitOfMeasure, this.freezed});
}

class Ingredient {
  String id;
  String name;

  Ingredient({this.id, this.name});
}