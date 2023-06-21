// ignore_for_file: invalid_annotation_target

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:model/recipe.dart';

import 'base_adapter.dart';

part 'recipe.g.dart';

@DataRepository([BaseAdapter], internalType: 'recipes')
class FlutterDataRecipe extends Recipe with DataModelMixin<FlutterDataRecipe> {
  FlutterDataRecipe(
      {required super.id,
      required super.name,
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
      super.videoUrl}) {
    init();
  }

  factory FlutterDataRecipe.fromJson(Map<String, dynamic> json) {
    final temp = Recipe.fromJson(json);
    return FlutterDataRecipe(
        id: temp.id,
        name: temp.name,
        availabilityMonths: temp.availabilityMonths,
        scraped: temp.scraped,
        cost: temp.cost,
        description: temp.description,
        difficulty: temp.difficulty,
        estimatedCookingTime: temp.estimatedCookingTime,
        estimatedPreparationTime: temp.estimatedPreparationTime,
        imgUrl: temp.imgUrl,
        ingredients: temp.ingredients,
        insertTimestamp: temp.insertTimestamp,
        note: temp.note,
        owner: temp.owner,
        preparation: temp.preparation,
        preparationSteps: temp.preparationSteps,
        rating: temp.rating,
        recipeUrl: temp.recipeUrl,
        relatedRecipes: temp.relatedRecipes,
        section: temp.section,
        servs: temp.servs,
        tags: temp.tags,
        updateTimestamp: temp.updateTimestamp,
        videoUrl: temp.videoUrl);
  }

  //fake override, needed to allow flutter_data builder to generate correct output
  // ignore: unnecessary_overrides
  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
