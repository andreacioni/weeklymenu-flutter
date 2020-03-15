import 'meals.dart';

class Menu {
  final String id;
  DateTime day;
  Meal meal;
  List<String> recipes;

  Menu({this.id, this.day, this.meal, this.recipes});
}
