import 'package:weekly_menu_app/dto/meal.dart';

import 'recipe.dart';

class Menu {
  String day;
  Map<String, List<Recipe>> meals;

  Menu({this.day, this.meals});
}