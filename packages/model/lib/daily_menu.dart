// ignore_for_file: invalid_annotation_target

import 'package:common/date.dart';
import 'package:common/memento.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectid/objectid.dart';
import 'package:intl/intl.dart';
import 'base_model.dart';
import 'converter/json_converter.dart';
import 'enums/meal.dart';

part 'daily_menu.g.dart';

extension DateAsId on Date {
  String formatId() {
    return format(DateFormat('y-MM-dd'));
  }
}

@JsonSerializable()
@CopyWith()
class DailyMenu extends BaseModel<DailyMenu> {
  @DateConverter()
  final Date date;

  final Map<Meal, DailyMenuMeal> meals;

  DailyMenu(
      {String? idx,
      required this.date,
      this.meals = const {},
      int? insertTimestamp,
      int? updateTimestamp})
      : super(
            idx: idx ?? ObjectId().hexString,
            insertTimestamp: insertTimestamp,
            updateTimestamp: updateTimestamp);

  factory DailyMenu.empty(Date date) => DailyMenu(
        date: date,
      );

  DailyMenu addRecipesToMeal(Meal meal, List<String> recipeIds) {
    final oldRecipes = getRecipesByMeal(meal);
    if (oldRecipes.isEmpty) {
      return copyWith(
          meals: {...meals, meal: DailyMenuMeal(recipeIds: recipeIds)});
    } else {
      return copyWith(meals: {
        ...meals,
        meal: DailyMenuMeal(
            recipeIds: <String>{...oldRecipes, ...recipeIds}.toList())
      });
    }
  }

  DailyMenu removeMeal(Meal meal) {
    return copyWith(meals: {...meals..removeWhere((key, _) => key == meal)});
  }

  List<String> getRecipesByMeal(Meal meal) => [...?meals[meal]?.recipeIds];

  DailyMenu removeRecipeFromMeal(Meal meal, String recipeId) {
    return removeRecipesFromMeal(meal, [recipeId]);
  }

  DailyMenu removeRecipesFromMeal(Meal meal, List<String> recipeIds) {
    final originalRecipeIds = getRecipesByMeal(meal);
    if (originalRecipeIds.isNotEmpty) {
      originalRecipeIds.removeWhere((recipe) => recipeIds.contains(recipe));
    }

    return copyWith(meals: {
      ...meals,
      ...{meal: DailyMenuMeal(recipeIds: originalRecipeIds)}
    });
  }

  DailyMenu replaceRecipeInMeal(
      Meal meal, String oldRecipeId, String newRecipeId) {
    final originalRecipeIds = getRecipesByMeal(meal);
    if (originalRecipeIds.isNotEmpty) {
      final oldIndex = originalRecipeIds.indexOf(oldRecipeId);
      originalRecipeIds.replaceRange(oldIndex, oldIndex + 1, [newRecipeId]);
      return copyWith(meals: {
        ...meals,
        ...{meal: DailyMenuMeal(recipeIds: originalRecipeIds)}
      });
    }

    return copyWith();
  }

  /// May contain **duplicates**
  List<String> get recipeIds {
    final ret = <String>[];

    for (final m in Meal.values) {
      final list = getRecipesByMeal(m);
      if (list.isNotEmpty) {
        ret.addAll(list);
      }
    }

    return ret;
  }

  bool get isToday => date.isToday;

  bool get isPast => date.isPast;

  bool get isEmpty => meals.isEmpty;
  bool get isNotEmpty => meals.isNotEmpty;

  factory DailyMenu.fromJson(Map<String, dynamic> json) =>
      _$DailyMenuFromJson(json);

  Map<String, dynamic> toJson() => _$DailyMenuToJson(this);

  @override
  DailyMenu clone() => DailyMenu.fromJson(toJson());

  @override
  String toString() {
    return 'DailyMenu{date: ${date.formatId()}, recipes: $meals}';
  }
}

@JsonSerializable()
@CopyWith()
class DailyMenuMeal implements Cloneable {
  @JsonKey(name: 'recipes')
  final List<String> recipeIds;
  const DailyMenuMeal({required this.recipeIds});

  factory DailyMenuMeal.fromJson(Map<String, dynamic> json) =>
      _$DailyMenuMealFromJson(json);

  Map<String, dynamic> toJson() => _$DailyMenuMealToJson(this);

  @override
  DailyMenuMeal clone() => DailyMenuMeal.fromJson(toJson());

  @override
  String toString() {
    return 'DailyMenuMeal{recipes: $recipeIds}';
  }
}
