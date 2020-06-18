import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../globals/memento.dart';
import '../datasource/network.dart';
import './enums/meals.dart';

part 'recipe.g.dart';

class RecipeOriginator extends Originator<Recipe> {
  RecipeOriginator(Recipe original) : super(original);

  void updateName(String newRecipeName) {
    setEdited();
    instance.name = newRecipeName;
    notifyListeners();
  }

  void updateDifficulty(String newValue) {
    setEdited();
    instance.difficulty = newValue;
    notifyListeners();
  }

  void updatePreparationTime(int newValue) {
    setEdited();
    instance.estimatedPreparationTime = newValue;
    notifyListeners();
  }

  void updateCookingTime(int newValue) {
    setEdited();
    instance.estimatedCookingTime = newValue;
    notifyListeners();
  }

  void updateRating(int newValue) {
    setEdited();
    instance.rating = newValue;
    notifyListeners();
  }

  void updateCost(int newValue) {
    setEdited();
    instance.cost = newValue;
    notifyListeners();
  }

  void addRecipeIngredient(RecipeIngredient recipeIngredient) {
    setEdited();
    if (instance.ingredients == null) {
      instance.ingredients = [recipeIngredient];
    } else {
      instance.ingredients.add(recipeIngredient);
    }
    notifyListeners();
  }

  void deleteRecipeIngredient(String recipeIngredientId) {
    if (instance.ingredients != null && instance.ingredients.isNotEmpty) {
      setEdited();
      instance.ingredients.removeWhere((recipeIngredient) =>
          recipeIngredient.ingredientId == recipeIngredientId);
      notifyListeners();
    }
  }

  void addTag(String newTag) {
    setEdited();
    if (instance.tags == null) {
      instance.tags = [newTag];
    } else {
      instance.tags.add(newTag);
    }
    notifyListeners();
  }

  void removeTag(String tagToRemove) {
    setEdited();
    if (instance.tags != null) {
      instance.tags.removeWhere((tag) => tag == tagToRemove);
      notifyListeners();
    }
  }

  void updateDescription(String newValue) {
    setEdited();
    instance.description = newValue;
    //notifyListeners(); NOTE: not needed because this field is controlled by TextEditorController
  }

  void updateImgUrl(String newValue) {
    setEdited();
    instance.imgUrl = newValue;
    notifyListeners();
  }

  void updatePreparation(String newValue) {
    setEdited();
    instance.preparation = newValue;
    //notifyListeners(); NOTE: not needed because this field is controlled by TextEditorController
  }

  void updateNote(String newValue) {
    setEdited();
    instance.note = newValue;
    //notifyListeners(); NOTE: not needed because this field is controlled by TextEditorController
  }

  void updateServs(int newValue) {
    setEdited();
    instance.servs = newValue;
    notifyListeners();
  }
}

@JsonSerializable()
class Recipe extends CloneableAndSaveable<Recipe> {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  @JsonKey(name: '_id')
  String id;
  String name;

  @JsonKey(includeIfNull: false)
  String description;
  @JsonKey(includeIfNull: false)
  int rating;
  @JsonKey(includeIfNull: false)
  int cost;
  @JsonKey(includeIfNull: false)
  String difficulty;
  @JsonKey(includeIfNull: false)
  List<int> availabilityMonths;
  @JsonKey(includeIfNull: false)
  int servs;
  @JsonKey(includeIfNull: false)
  int estimatedCookingTime;
  @JsonKey(includeIfNull: false)
  int estimatedPreparationTime;

  @JsonKey(includeIfNull: false, defaultValue: [])
  List<RecipeIngredient> ingredients;

  @JsonKey(includeIfNull: false)
  String preparation;
  @JsonKey(includeIfNull: false)
  String note;

  @JsonKey(includeIfNull: false)
  String imgUrl;
  @JsonKey(includeIfNull: false)
  String recipeUrl;
  @JsonKey(includeIfNull: false)
  List<String> tags;

  @JsonKey(ignore: true)
  String owner;

  Recipe(
      {this.id,
      this.name,
      this.description,
      this.ingredients = const <RecipeIngredient>[],
      this.difficulty,
      this.rating,
      this.cost,
      this.servs,
      this.estimatedPreparationTime,
      this.estimatedCookingTime,
      this.imgUrl,
      this.tags});

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  factory Recipe.empty() {
    return Recipe(
      name: '',
      description: '',
      ingredients: [],
    );
  }

  @override
  Future<Recipe> save() async {
    await _restApi.patchRecipe(id, this.toJson());
    ingredients.forEach((recipeIngredient) => recipeIngredient.save());
    return this;
  }

  Recipe clone() => Recipe.fromJson(this.toJson());

  @override
  String toString() => name;
  @override
  bool operator ==(o) => o is Recipe && o.id == this.id;
  @override
  int get hashCode => id.hashCode;
}

class RecipeIngredientOriginator extends Originator<RecipeIngredient> {
  RecipeIngredientOriginator(RecipeIngredient original) : super(original);

  void setQuantity(double newValue) {
    setEdited();
    instance.quantity = newValue;
    notifyListeners();
  }

  void setUom(String newValue) {
    setEdited();
    instance.unitOfMeasure = newValue;
    notifyListeners();
  }

  void setFreezed(bool newValue) {
    setEdited();
    instance.freezed = newValue;
    notifyListeners();
  }
}

@JsonSerializable()
class RecipeIngredient extends CloneableAndSaveable<RecipeIngredient> {
  @JsonKey(ignore: true)
  String recipeId;

  @JsonKey(name: 'ingredient')
  String ingredientId;

  @JsonKey(includeIfNull: false)
  double quantity;
  @JsonKey(includeIfNull: false)
  String unitOfMeasure;
  @JsonKey(includeIfNull: false)
  bool freezed;

  RecipeIngredient(
      {@required this.ingredientId,
      this.quantity = 0,
      this.unitOfMeasure,
      this.freezed = false}) {
    if (quantity == null) {
      this.quantity = 0;
    }

    if (freezed == null) {
      this.freezed = false;
    }
  }

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeIngredientToJson(this);

  @override
  Future<RecipeIngredient> save() {
    //No patch here (this is done by the recipe class)
    return Future.delayed(Duration.zero, () => this);
  }

  @override
  RecipeIngredient clone() => RecipeIngredient.fromJson(this.toJson());

  @override
  bool operator ==(o) =>
      o is RecipeIngredient && o.ingredientId == this.ingredientId;
  @override
  int get hashCode => ingredientId.hashCode;
}

class MealRecipe {
  final Meal meal;
  final Recipe recipe;
  MealRecipe(this.meal, this.recipe);
}
