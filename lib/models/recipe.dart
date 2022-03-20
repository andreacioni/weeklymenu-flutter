// ignore_for_file: invalid_annotation_target

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/globals/memento.dart';
import 'package:weekly_menu_app/models/base_model.dart';

import 'enums/meal.dart';
import 'menu.dart';

part 'recipe.g.dart';

class RecipeOriginator extends Originator<Recipe> {
  RecipeOriginator(Recipe original) : super(original);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
@DataRepository([BaseAdapter])
@CopyWith()
class Recipe extends BaseModel<Recipe> {
  final String name;

  @JsonKey(includeIfNull: false)
  final String? description;

  @JsonKey(includeIfNull: false)
  final int? rating;

  @JsonKey(includeIfNull: false)
  final int? cost;

  @JsonKey(includeIfNull: false)
  final String? difficulty;

  @JsonKey(includeIfNull: false)
  final List<int> availabilityMonths;

  @JsonKey(includeIfNull: false)
  final int? servs;

  @JsonKey(includeIfNull: false)
  final int? estimatedCookingTime;

  @JsonKey(includeIfNull: false)
  final int? estimatedPreparationTime;

  @JsonKey(includeIfNull: false)
  final List<RecipeIngredient> ingredients;

  @JsonKey(includeIfNull: false)
  final String? preparation;

  @JsonKey(includeIfNull: false)
  final String? note;

  @JsonKey(includeIfNull: false)
  final String? imgUrl;

  @JsonKey(includeIfNull: false)
  final String? recipeUrl;

  @JsonKey(includeIfNull: false)
  final List<String> tags;

  @JsonKey(ignore: true)
  final String? owner;

  Recipe({
    required String id,
    required this.name,
    this.description,
    this.ingredients = const <RecipeIngredient>[],
    this.difficulty,
    this.rating,
    this.cost,
    this.availabilityMonths = const <int>[],
    this.servs,
    this.estimatedPreparationTime,
    this.estimatedCookingTime,
    this.imgUrl,
    this.tags = const <String>[],
    this.preparation,
    this.recipeUrl,
    this.note,
    this.owner,
  }) : super(id: id);

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  Recipe clone() => Recipe.fromJson(this.toJson());

  @override
  String toString() => name;
}

@JsonSerializable()
class RecipeIngredient {
  @JsonKey(name: 'ingredient')
  final String ingredientId;

  @JsonKey(includeIfNull: false)
  final double? quantity;
  @JsonKey(includeIfNull: false)
  final String? unitOfMeasure;
  @JsonKey(includeIfNull: false)
  final bool? freezed;

  RecipeIngredient(
      {required this.ingredientId,
      this.unitOfMeasure,
      quantity = 0,
      freezed = false})
      : this.quantity = quantity ?? 0,
        this.freezed = freezed ?? false;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeIngredientToJson(this);
}

class MealRecipe {
  final Meal meal;
  final Recipe recipe;
  MealRecipe(this.meal, this.recipe);
}
