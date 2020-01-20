import './ingredient.dart';

class Recipe {
  String id;
  
  String name;
  String description;
  int rating;
  List<int> availabilityMonths;
  
  int servs;
  int estimatedCookingTime;
  int estimatedPreparationTime;

  List<Ingredient> ingredients;

  String note;
  
  String recipeUrl;
  List<String> tags;

  String owner;

  Recipe({this.name});
}