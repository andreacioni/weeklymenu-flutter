import 'recipe.dart';
import 'meals.dart';

class Menu {
  String day;
  Map<Meal, List<Recipe>> meals;

  Menu({this.day, this.meals});
}