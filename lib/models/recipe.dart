import 'package:flutter/foundation.dart';

import './ingredient.dart';

class Recipe {
  String id;
  
  String name;
  String description;
  int rating;
  int cost;
  int difficulty;
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

  Recipe({@required this.id, this.name, this.description, this.ingredients = const [], this.difficulty = 0, this.rating = 0, this.cost = 0, this.servs = 0, this.estimatedPreparationTime = 0, this.estimatedCookingTime = 0, this.imgUrl, this.tags = const []});
}