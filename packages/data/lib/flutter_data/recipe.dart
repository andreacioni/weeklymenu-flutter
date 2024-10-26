// ignore_for_file: invalid_annotation_target

import 'dart:async';

import 'package:common/log.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:model/recipe.dart';

import 'base_adapter.dart';

part 'recipe.g.dart';

@DataRepository([RecipeAdapter, BaseAdapter], internalType: 'recipes')
class FlutterDataRecipe extends Recipe with DataModelMixin<FlutterDataRecipe> {
  FlutterDataRecipe(
      {required super.idx,
      required super.name,
      required super.language,
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
        idx: temp.idx,
        name: temp.name,
        language: temp.language,
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

  @override
  String get id => idx;

  //fake override, needed to allow flutter_data builder to generate correct output
  // ignore: unnecessary_overrides
  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}

mixin RecipeAdapter<T extends DataModelMixin<FlutterDataRecipe>>
    on RemoteAdapter<FlutterDataRecipe> {
  @DataFinder()
  Future<List<FlutterDataRecipe>> findAllCustom(
      {bool? remote,
      bool? background,
      Map<String, dynamic>? params,
      Map<String, String>? headers,
      bool? syncLocal,
      OnSuccessAll<FlutterDataRecipe>? onSuccess,
      OnErrorAll<FlutterDataRecipe>? onError,
      DataRequestLabel? label}) {
    onError = (err, _, __) {
      return [];
    };
    return super.findAll(
        remote: remote,
        background: background,
        params: params,
        headers: headers,
        syncLocal: syncLocal,
        onSuccess: onSuccess,
        onError: onError,
        label: label);
  }

  @DataFinder()
  Future<FlutterDataRecipe?> findOneCustom(Object id,
      {bool? remote,
      bool? background,
      Map<String, dynamic>? params,
      Map<String, String>? headers,
      OnSuccessOne<FlutterDataRecipe>? onSuccess,
      OnErrorOne<FlutterDataRecipe>? onError,
      DataRequestLabel? label}) {
    var originalOnError = onError;
    onError = (err, label, adapter) {
      if (err is OfflineException && label.kind == 'findOne') {
        return null;
      }

      return originalOnError?.call(err, label, adapter);
    };
    return super.findOne(id,
        remote: remote,
        background: background,
        params: params,
        headers: headers,
        onSuccess: onSuccess,
        onError: onError,
        label: label);
  }
}

@DataRepository([BaseAdapter, ExternalRecipeAdapter],
    internalType: 'external_recipes')
class FlutterDataExternalRecipe extends ExternalRecipe
    with DataModelMixin<FlutterDataExternalRecipe> {
  FlutterDataExternalRecipe(
      {required super.name,
      required super.language,
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

  factory FlutterDataExternalRecipe.fromJson(Map<String, dynamic> json) {
    final temp = Recipe.fromJson(json);
    return FlutterDataExternalRecipe(
        name: temp.name,
        language: temp.language,
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

  @override
  String get id => idx;

  //fake override, needed to allow flutter_data builder to generate correct output
  // ignore: unnecessary_overrides
  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}

mixin ExternalRecipeAdapter<T extends DataModelMixin<FlutterDataExternalRecipe>>
    on RemoteAdapter<FlutterDataExternalRecipe> {
  static const _BASE_PATH = 'recipes/explore';
  @override
  String urlForFindAll(Map<String, dynamic> params) => _BASE_PATH;

  @override
  FutureOr<Map<String, dynamic>> get defaultParams => {'per_page': 30};
}
