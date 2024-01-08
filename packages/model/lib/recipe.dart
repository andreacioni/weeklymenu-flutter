// ignore_for_file: invalid_annotation_target

import 'package:common/memento.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:model/base_model.dart';
import 'package:objectid/objectid.dart';

import 'enums/meal.dart';

part 'recipe.g.dart';

class RecipeOriginator extends Originator<Recipe> {
  RecipeOriginator(Recipe original, [bool unsaved = false])
      : super(original.copyWith()) {
    if (unsaved) setEdited();
  }
}

@JsonSerializable(explicitToJson: true, anyMap: true)
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

  final String? videoUrl;

  final List<String> tags;

  final String? section;

  final List<RelatedRecipe> relatedRecipes;

  final bool? scraped;

  @JsonKey(ignore: true)
  final String? owner;

  Recipe(
      {String? idx,
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
      this.videoUrl,
      this.tags = const <String>[],
      this.relatedRecipes = const <RelatedRecipe>[],
      this.section = 'Dinner',
      this.preparation,
      this.preparationSteps = const <RecipePreparationStep>[],
      this.recipeUrl,
      this.note,
      this.scraped,
      this.owner,
      int? insertTimestamp,
      int? updateTimestamp})
      : super(
            idx: idx ?? ObjectId().hexString,
            insertTimestamp: insertTimestamp,
            updateTimestamp: updateTimestamp);

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  @override
  Recipe clone() => Recipe.fromJson(toJson());

  @override
  String toString() => name;

  @override
  int get hashCode => idx.hashCode;

  @override
  bool operator ==(Object other) {
    return (other is Recipe) && (other.idx == idx);
  }
}

@JsonSerializable()
@CopyWith()
class RelatedRecipe {
  final String id;

  const RelatedRecipe({required this.id});

  factory RelatedRecipe.fromJson(Map<String, dynamic> json) =>
      _$RelatedRecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RelatedRecipeToJson(this);
}

@JsonSerializable()
@CopyWith()
class RecipePreparationStep {
  final String? description;

  const RecipePreparationStep({this.description});

  factory RecipePreparationStep.fromJson(Map<String, dynamic> json) =>
      _$RecipePreparationStepFromJson(json);

  Map<String, dynamic> toJson() => _$RecipePreparationStepToJson(this);
}

@JsonSerializable()
@CopyWith()
class RecipeIngredient {
  @JsonKey(name: 'name')
  final String ingredientName;

  final double? quantity;
  final String? unitOfMeasure;
  final bool? freezed;

  RecipeIngredient(
      {required this.ingredientName,
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

@JsonSerializable(explicitToJson: true, anyMap: true)
@CopyWith()
class ExternalRecipe extends Recipe {
  ExternalRecipe(
      {required super.name,
      super.availabilityMonths,
      super.cost,
      super.description,
      super.difficulty,
      super.estimatedCookingTime,
      super.estimatedPreparationTime,
      super.imgUrl,
      super.ingredients,
      super.insertTimestamp,
      super.note,
      super.owner,
      super.preparation,
      super.preparationSteps,
      super.rating,
      super.recipeUrl,
      super.relatedRecipes,
      super.scraped,
      super.section,
      super.servs,
      super.tags,
      super.updateTimestamp,
      super.videoUrl});
  Map<String, dynamic> toJson() => _$ExternalRecipeToJson(this);
}
