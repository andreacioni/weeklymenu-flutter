import './ingredient.dart';

class Recipe {
  String id;
  
  String name;
  String description;
  int rating;
  int cost;
  List<int> availabilityMonths;
  
  int servs;
  int estimatedCookingTime;
  int estimatedPreparationTime;

  List<RecipeIngredient> ingredients;

  String preparation;
  String note;
  
  String recipeUrl;
  List<String> tags;

  String owner;

  Recipe({this.name, this.description, this.ingredients, this.tags});
}