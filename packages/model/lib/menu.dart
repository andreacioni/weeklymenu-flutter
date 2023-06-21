// ignore_for_file: invalid_annotation_target

import 'package:common/date.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

import 'base_model.dart';
import 'converter/json_converter.dart';
import 'enums/meal.dart';

part 'menu.g.dart';

@JsonSerializable()
@CopyWith()
class Menu extends BaseModel<Menu> {
  @DateConverter()
  Date date;

  Meal meal;

  @JsonKey(includeIfNull: false)
  List<String> recipes;

  Menu(
      {required Object? id,
      required this.date,
      required this.meal,
      this.recipes = const [],
      int? insertTimestamp,
      int? updateTimestamp})
      : super(
            id: id,
            insertTimestamp: insertTimestamp,
            updateTimestamp: updateTimestamp);

  Menu addRecipe(String recipeId) {
    return this.copyWith(recipes: [...recipes, recipeId]);
  }

  Menu addRecipes(List<String> recipeIds) {
    return this.copyWith(recipes: [...recipes, ...recipeIds]);
  }

  Menu removeRecipeById(String id) {
    return this
        .copyWith(recipes: recipes..removeWhere((element) => element == id));
  }

  Menu removeRecipeByIdList(List<String> ids) {
    return this.copyWith(recipes: recipes..removeWhere((e) => ids.contains(e)));
  }

  Menu removeAllRecipes() {
    return this.copyWith(recipes: []);
  }

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  @override
  Menu clone() => Menu.fromJson(toJson());
}

@CopyWith()
class DailyMenu with EquatableMixin {
  final Date day;
  final List<Menu> menus;

  DailyMenu({required this.day, required this.menus})
      : assert(menus.every((element) => element.date == day));

  List<String> getRecipeIdsByMeal(Meal meal) {
    return recipeIdsByMeal[meal] ?? [];
  }

  List<Menu> getMenusByMeal(Meal meal) {
    return menus.where((m) => m.meal == meal).toList();
  }

  void addRecipeIdListToMeal(Meal meal, List<String> recipeIds) {
    if (recipeIds.isNotEmpty) {
      var menu = getMenuByMeal(meal);

      if (menu != null) {
        menu.addRecipes(recipeIds);
      }
    }
  }

  Map<Meal, List<String>> get recipeIdsByMeal {
    Map<Meal, List<String>> recipeIdsByMeal = {};

    if (menus.isNotEmpty) {
      Meal.values.forEach((meal) {
        final menuMeal = menus.firstWhereOrNull((menu) => menu.meal == meal);

        if (menuMeal != null) {
          recipeIdsByMeal[meal] = menuMeal.recipes;
        } else {
          recipeIdsByMeal[meal] = [];
        }
      });
    }

    return recipeIdsByMeal;
  }

  Menu? getMenuByMeal(Meal meal) =>
      menus.firstWhereOrNull((menu) => menu.meal == meal);

  bool get isToday => day.isToday;

  bool get isPast => day.isPast;

  @override
  List<Object?> get props => [
        day,
        menus.map((e) => e.id).toSet(),
        menus.map((e) => e.recipes).flattened.toSet()
      ];
}
