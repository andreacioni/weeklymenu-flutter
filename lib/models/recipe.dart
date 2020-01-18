import './ingredient.dart';

class Recipe {
  String id;
  String name;
  String description;
  String note;
  List<int> availabilityMonths;
  List<Ingredient> ingredients;
  int servs;
  int estimatedCookingTime;
  int estimatedPreparationTime;
  int rating;
  String recipeUrl;
  List<String> tags;

  String owner;

  Recipe({this.name});
}