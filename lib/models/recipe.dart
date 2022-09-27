// ignore_for_file: invalid_annotation_target

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectid/objectid.dart';
import 'package:weekly_menu_app/globals/memento.dart';
import 'package:weekly_menu_app/models/base_model.dart';

import 'enums/meal.dart';

part 'recipe.g.dart';

class RecipeOriginator extends Originator<Recipe> {
  RecipeOriginator(Recipe original) : super(original);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
@DataRepository([BaseAdapter], internalType: 'recipes')
@CopyWith()
class Recipe extends BaseModel<Recipe> {
  final String name;

  final String? description;

  final int? rating;

  final int? cost;

  final String? difficulty;

  final List<int> availabilityMonths;

  final int? servs;

  final int? estimatedCookingTime;

  final int? estimatedPreparationTime;

  final List<RecipeIngredient> ingredients;

  final String? preparation;

  final List<RecipePreparationStep> preparationSteps;

  final String? note;

  final String? imgUrl;

  final String? recipeUrl;

  final List<String> tags;

  @JsonKey(ignore: true)
  final String? owner;

  Recipe(
      {String? id,
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
      this.preparationSteps = const <RecipePreparationStep>[],
      this.recipeUrl,
      this.note,
      this.owner,
      int? insertTimestamp,
      int? updateTimestamp})
      : super(
            id: id ?? ObjectId().hexString,
            insertTimestamp: insertTimestamp,
            updateTimestamp: updateTimestamp);

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  Recipe clone() => Recipe.fromJson(this.toJson());

  @override
  String toString() => name;
}

@JsonSerializable()
@CopyWith()
class RecipePreparationStep {
  final int position;
  final String? description;

  const RecipePreparationStep({this.description, this.position = 0});

  factory RecipePreparationStep.fromJson(Map<String, dynamic> json) =>
      _$RecipePreparationStepFromJson(json);

  Map<String, dynamic> toJson() => _$RecipePreparationStepToJson(this);
}

@JsonSerializable()
@CopyWith()
class RecipeIngredient {
  @JsonKey(name: 'ingredient')
  final String ingredientId;

  final double? quantity;
  final String? unitOfMeasure;
  final bool? freezed;

  RecipeIngredient(
      {required this.ingredientId,
      this.unitOfMeasure,
      quantity = 0.0,
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
