import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../globals/utils.dart' as utils;
import '../datasource/network.dart';
import '../globals/utils.dart';
import './enums/meals.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  static final _dateParser = DateFormat('y-M-d');

  @JsonKey(name: '_id')
  String id;
  @JsonKey(toJson: dateToJson, fromJson: dateFromJson)
  DateTime date;
  Meal meal;

  @JsonKey(includeIfNull: false, defaultValue: [])
  List<String> recipes;

  Menu({this.id, this.date, this.meal, this.recipes});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  static String dateToJson(DateTime date) => _dateParser.format(date);

  static DateTime dateFromJson(String date) => _dateParser.parse(date);
}

class DailyMenu with ChangeNotifier {
  DateTime day;
  Map<Meal, List<String>> recipeIdsByMeal;

  DailyMenu(this.day, this.recipeIdsByMeal);

  factory DailyMenu.byMenuList(DateTime day, List<Menu> menuList) {
    Map<Meal, List<String>> recipeIdsByMeal = {};

    if (menuList != null && menuList.isNotEmpty) {
      Meal.values.forEach((meal) {
        final Menu menuMeal = menuList != null
            ? menuList.firstWhere((menu) => menu.meal == meal,
                orElse: () => null)
            : null;

        if (menuMeal != null) {
          recipeIdsByMeal[meal] = menuMeal.recipes;
        } else {
          recipeIdsByMeal[meal] = [];
        }
      });
    }

    return DailyMenu(day, recipeIdsByMeal);
  }

  void moveRecipeToMeal(Meal from, to, String recipeId) {
    assert((recipeIdsByMeal[from] != null) && (recipeIdsByMeal[from].isNotEmpty));

    final initialLength = recipeIdsByMeal[from].length;

    List<String> recipeIdsForMeal = recipeIdsByMeal[from];
    recipeIdsForMeal.removeWhere((id) => recipeId == id);

    assert(initialLength != recipeIdsForMeal.length);

    if(recipeIdsByMeal[to] == null) {
      recipeIdsByMeal[to] = <String>[recipeId];
    } else {
      recipeIdsByMeal[to].add(recipeId);
    }

    notifyListeners();
  }

  List<String> getRecipeIdsByMeal(Meal meal) {
    return recipeIdsByMeal[meal] == null ? [] : recipeIdsByMeal[meal];
  }

  List<Menu> getMenusByMeal(Meal meal) {
    return recipeIdsByMeal[meal] == null ? [] : recipeIdsByMeal[meal];
  }

  bool get isToday  => utils.dateTimeToDate(DateTime.now()) == day;
  
  bool get isPast => (utils
        .dateTimeToDate(day)
        .add(Duration(days: 1))
        .isBefore(DateTime.now()));

}
