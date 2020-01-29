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

  Recipe({this.name, this.description, this.ingredients, this.difficulty = 0, this.rating = 0, this.cost = 0, this.servs, this.estimatedPreparationTime, this.estimatedCookingTime, this.imgUrl, this.tags});
}