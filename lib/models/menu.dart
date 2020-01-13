import 'recipe.dart';
import 'meals.dart';

class Menu {
  DateTime day;
  Map<Meal, List<Recipe>> meals;

  Menu({this.day, this.meals});
}