import 'package:flutter/foundation.dart';

import 'recipe.dart';
import 'meals.dart';

class Menu {
  final String id;
  DateTime day;
  Meal meal;
  List<String> recipes;

  Menu({@required this.id, this.day, this.meal, this.recipes});
}
