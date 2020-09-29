import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/syncronizer/syncro.dart';

import '../globals/memento.dart';
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

  void deleteRecipeIngredient(Id recipeIngredientId) {
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

  Id get id => instance.id;

  String get name => instance.name;

  String get description => instance.description;

  List<RecipeIngredient> get ingredients => instance.ingredients;

  String get difficulty => instance.difficulty;

  int get rating => instance.rating;

  int get cost => instance.cost;

  List<int> get availabilityMonths => [...instance.availabilityMonths];

  int get servs => instance.servs;

  int get estimatedPreparationTime => instance.estimatedPreparationTime;

  int get estimatedCookingTime => instance.estimatedCookingTime;

  String get imgUrl => instance.imgUrl;

  String get preparation => instance.preparation;

  String get recipeUrl => instance.recipeUrl;

  String get note => instance.note;

  List<String> get tags => instance.tags != null ? [...instance.tags] : null;

  String get owner => instance.owner;

  Map<String, dynamic> toJson() => instance.toJson();
}

@JsonSerializable(explicitToJson: true)
class Recipe extends BaseModel<Recipe> {
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
    Id id, {
    this.name,
    this.description,
    this.ingredients = const <RecipeIngredient>[],
    this.difficulty,
    this.rating,
    this.cost,
    this.availabilityMonths,
    this.servs,
    this.estimatedPreparationTime,
    this.estimatedCookingTime,
    this.imgUrl,
    this.tags = const <String>[],
    this.preparation,
    this.recipeUrl,
    this.note,
    this.owner,
  }) : super(id);

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  Recipe clone() => Recipe.fromJson(this.toJson());

  @override
  String toString() => name;
  @override
  bool operator ==(o) => o is Recipe && o.id == this.id;
  @override
  int get hashCode => id.hashCode;
}

@JsonSerializable()
class RecipeIngredient extends Cloneable<RecipeIngredient> with ChangeNotifier {
  @JsonKey(ignore: true)
  String recipeId;

  @JsonKey(name: 'ingredient')
  Id ingredientId;

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

  void update(
      {double quantity = -1, String unitOfMeasure, bool freezed = false}) {
    if (quantity > 0) {
      this.quantity = quantity;
    }

    if (unitOfMeasure != null) {
      this.unitOfMeasure = unitOfMeasure;
    }

    if (freezed != null) {
      this.freezed = freezed;
    }

    notifyListeners();
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
  final RecipeOriginator recipe;
  MealRecipe(this.meal, this.recipe);
}
