import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../datasource/network.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe with ChangeNotifier {
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

  bool _edited = false;

  Recipe(
      {this.id,
      this.name,
      this.description,
      this.ingredients = const <RecipeIngredient>[],
      this.difficulty,
      this.rating = 0,
      this.cost = 0,
      this.servs = 0,
      this.estimatedPreparationTime = 0,
      this.estimatedCookingTime = 0,
      this.imgUrl,
      this.tags});

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  void updateDifficulty(String newValue) {
    _edited = true;
    difficulty = newValue;
    notifyListeners();
  }

  void updatePreparationTime(int newValue) {
    _edited = true;
    estimatedPreparationTime = newValue;
    notifyListeners();
  }

  void updateCookingTime(int newValue) {
    _edited = true;
    estimatedCookingTime = newValue;
    notifyListeners();
  }

  void updateRating(int newValue) {
    _edited = true;
    rating = newValue;
    notifyListeners();
  }

  void updateCost(int newValue) {
    _edited = true;
    cost = newValue;
    notifyListeners();
  }

  void addRecipeIngredient(RecipeIngredient recipeIngredient) {
    _edited = true;
    if (ingredients == null) {
      ingredients = [recipeIngredient];
    } else {
      ingredients.add(recipeIngredient);
    }
    notifyListeners();
  }

  void deleteRecipeIngredient(String recipeIngredientId) {
    if (ingredients != null && ingredients.isNotEmpty) {
      _edited = true;
      ingredients.removeWhere((recipeIngredient) =>
          recipeIngredient.ingredientId == recipeIngredientId);
      notifyListeners();
    }
  }

  void addTag(String newTag) {
    _edited = true;
    if (tags == null) {
      tags = [newTag];
    } else {
      tags.add(newTag);
    }
    notifyListeners();
  }

  void removeTag(String tagToRemove) {
    _edited = true;
    if (tags != null) {
      tags.removeWhere((tag) => tag == tagToRemove);
      notifyListeners();
    }
  }

  void updateDescription(String newValue) {
    _edited = true;
    description = newValue;
    notifyListeners();
  }

  void updateImgUrl(String newValue) {
    _edited = true;
    imgUrl = newValue;
    notifyListeners();
  }

  void updatePreparation(String newValue) {
    _edited = true;
    preparation = newValue;
    notifyListeners();
  }

  void updateNote(String newValue) {
    _edited = true;
    note = newValue;
    notifyListeners();
  }

  void updateServs(int newValue) {
    _edited = true;
    servs = newValue;
    notifyListeners();
  }

  bool get isResourceEdited => _edited;

  Future<void> save() async {
    await _restApi.patchRecipe(id, this.toJson());
    _edited = false;
    ingredients.forEach((recipeIngredient) => recipeIngredient.save());
  }

  @override
  String toString() => name;
  @override
  bool operator ==(o) => o is Recipe && o.id == this.id;
  @override
  int get hashCode => id.hashCode;
}

@JsonSerializable()
class RecipeIngredient with ChangeNotifier {
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

  bool _edited = false;

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

  void setQuantity(double newValue) {
    _edited = true;
    quantity = newValue;
    notifyListeners();
  }

  void setUom(String newValue) {
    _edited = true;
    unitOfMeasure = newValue;
    notifyListeners();
  }

  void setFreezed(bool newValue) {
    _edited = true;
    freezed = newValue;
    notifyListeners();
  }

  bool get isResourceEdited => _edited;

  Future<void> save() {
    //No patch here (this is done by the recipe class)
    _edited = false;
    return Future.delayed(Duration.zero);
  }

  @override
  bool operator ==(o) =>
      o is RecipeIngredient && o.ingredientId == this.ingredientId;
  @override
  int get hashCode => ingredientId.hashCode;
}
