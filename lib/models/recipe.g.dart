// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeCWProxy {
  Recipe availabilityMonths(List<int> availabilityMonths);

  Recipe cost(int? cost);

  Recipe description(String? description);

  Recipe difficulty(String? difficulty);

  Recipe estimatedCookingTime(int? estimatedCookingTime);

  Recipe estimatedPreparationTime(int? estimatedPreparationTime);

  Recipe id(String? id);

  Recipe imgUrl(String? imgUrl);

  Recipe ingredients(List<RecipeIngredient> ingredients);

  Recipe insertTimestamp(int? insertTimestamp);

  Recipe name(String name);

  Recipe note(String? note);

  Recipe owner(String? owner);

  Recipe preparation(String? preparation);

  Recipe rating(int? rating);

  Recipe recipeUrl(String? recipeUrl);

  Recipe servs(int? servs);

  Recipe tags(List<String> tags);

  Recipe updateTimestamp(int? updateTimestamp);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Recipe(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Recipe(...).copyWith(id: 12, name: "My name")
  /// ````
  Recipe call({
    List<int>? availabilityMonths,
    int? cost,
    String? description,
    String? difficulty,
    int? estimatedCookingTime,
    int? estimatedPreparationTime,
    String? id,
    String? imgUrl,
    List<RecipeIngredient>? ingredients,
    int? insertTimestamp,
    String? name,
    String? note,
    String? owner,
    String? preparation,
    int? rating,
    String? recipeUrl,
    int? servs,
    List<String>? tags,
    int? updateTimestamp,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecipe.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecipe.copyWith.fieldName(...)`
class _$RecipeCWProxyImpl implements _$RecipeCWProxy {
  final Recipe _value;

  const _$RecipeCWProxyImpl(this._value);

  @override
  Recipe availabilityMonths(List<int> availabilityMonths) =>
      this(availabilityMonths: availabilityMonths);

  @override
  Recipe cost(int? cost) => this(cost: cost);

  @override
  Recipe description(String? description) => this(description: description);

  @override
  Recipe difficulty(String? difficulty) => this(difficulty: difficulty);

  @override
  Recipe estimatedCookingTime(int? estimatedCookingTime) =>
      this(estimatedCookingTime: estimatedCookingTime);

  @override
  Recipe estimatedPreparationTime(int? estimatedPreparationTime) =>
      this(estimatedPreparationTime: estimatedPreparationTime);

  @override
  Recipe id(String? id) => this(id: id);

  @override
  Recipe imgUrl(String? imgUrl) => this(imgUrl: imgUrl);

  @override
  Recipe ingredients(List<RecipeIngredient> ingredients) =>
      this(ingredients: ingredients);

  @override
  Recipe insertTimestamp(int? insertTimestamp) =>
      this(insertTimestamp: insertTimestamp);

  @override
  Recipe name(String name) => this(name: name);

  @override
  Recipe note(String? note) => this(note: note);

  @override
  Recipe owner(String? owner) => this(owner: owner);

  @override
  Recipe preparation(String? preparation) => this(preparation: preparation);

  @override
  Recipe rating(int? rating) => this(rating: rating);

  @override
  Recipe recipeUrl(String? recipeUrl) => this(recipeUrl: recipeUrl);

  @override
  Recipe servs(int? servs) => this(servs: servs);

  @override
  Recipe tags(List<String> tags) => this(tags: tags);

  @override
  Recipe updateTimestamp(int? updateTimestamp) =>
      this(updateTimestamp: updateTimestamp);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Recipe(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Recipe(...).copyWith(id: 12, name: "My name")
  /// ````
  Recipe call({
    Object? availabilityMonths = const $CopyWithPlaceholder(),
    Object? cost = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? difficulty = const $CopyWithPlaceholder(),
    Object? estimatedCookingTime = const $CopyWithPlaceholder(),
    Object? estimatedPreparationTime = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? imgUrl = const $CopyWithPlaceholder(),
    Object? ingredients = const $CopyWithPlaceholder(),
    Object? insertTimestamp = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? owner = const $CopyWithPlaceholder(),
    Object? preparation = const $CopyWithPlaceholder(),
    Object? rating = const $CopyWithPlaceholder(),
    Object? recipeUrl = const $CopyWithPlaceholder(),
    Object? servs = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? updateTimestamp = const $CopyWithPlaceholder(),
  }) {
    return Recipe(
      availabilityMonths: availabilityMonths == const $CopyWithPlaceholder() ||
              availabilityMonths == null
          ? _value.availabilityMonths
          // ignore: cast_nullable_to_non_nullable
          : availabilityMonths as List<int>,
      cost: cost == const $CopyWithPlaceholder()
          ? _value.cost
          // ignore: cast_nullable_to_non_nullable
          : cost as int?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      difficulty: difficulty == const $CopyWithPlaceholder()
          ? _value.difficulty
          // ignore: cast_nullable_to_non_nullable
          : difficulty as String?,
      estimatedCookingTime: estimatedCookingTime == const $CopyWithPlaceholder()
          ? _value.estimatedCookingTime
          // ignore: cast_nullable_to_non_nullable
          : estimatedCookingTime as int?,
      estimatedPreparationTime:
          estimatedPreparationTime == const $CopyWithPlaceholder()
              ? _value.estimatedPreparationTime
              // ignore: cast_nullable_to_non_nullable
              : estimatedPreparationTime as int?,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      imgUrl: imgUrl == const $CopyWithPlaceholder()
          ? _value.imgUrl
          // ignore: cast_nullable_to_non_nullable
          : imgUrl as String?,
      ingredients:
          ingredients == const $CopyWithPlaceholder() || ingredients == null
              ? _value.ingredients
              // ignore: cast_nullable_to_non_nullable
              : ingredients as List<RecipeIngredient>,
      insertTimestamp: insertTimestamp == const $CopyWithPlaceholder()
          ? _value.insertTimestamp
          // ignore: cast_nullable_to_non_nullable
          : insertTimestamp as int?,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      owner: owner == const $CopyWithPlaceholder()
          ? _value.owner
          // ignore: cast_nullable_to_non_nullable
          : owner as String?,
      preparation: preparation == const $CopyWithPlaceholder()
          ? _value.preparation
          // ignore: cast_nullable_to_non_nullable
          : preparation as String?,
      rating: rating == const $CopyWithPlaceholder()
          ? _value.rating
          // ignore: cast_nullable_to_non_nullable
          : rating as int?,
      recipeUrl: recipeUrl == const $CopyWithPlaceholder()
          ? _value.recipeUrl
          // ignore: cast_nullable_to_non_nullable
          : recipeUrl as String?,
      servs: servs == const $CopyWithPlaceholder()
          ? _value.servs
          // ignore: cast_nullable_to_non_nullable
          : servs as int?,
      tags: tags == const $CopyWithPlaceholder() || tags == null
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<String>,
      updateTimestamp: updateTimestamp == const $CopyWithPlaceholder()
          ? _value.updateTimestamp
          // ignore: cast_nullable_to_non_nullable
          : updateTimestamp as int?,
    );
  }
}

extension $RecipeCopyWith on Recipe {
  /// Returns a callable class that can be used as follows: `instanceOfRecipe.copyWith(...)` or like so:`instanceOfRecipe.copyWith.fieldName(...)`.
  _$RecipeCWProxy get copyWith => _$RecipeCWProxyImpl(this);
}

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $RecipeLocalAdapter on LocalAdapter<Recipe> {
  static final Map<String, RelationshipMeta> _kRecipeRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kRecipeRelationshipMetas;

  @override
  Recipe deserialize(map) {
    map = transformDeserialize(map);
    return Recipe.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _recipesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $RecipeHiveLocalAdapter = HiveLocalAdapter<Recipe>
    with $RecipeLocalAdapter;

class $RecipeRemoteAdapter = RemoteAdapter<Recipe> with BaseAdapter<Recipe>;

final internalRecipesRemoteAdapterProvider = Provider<RemoteAdapter<Recipe>>(
    (ref) => $RecipeRemoteAdapter(
        $RecipeHiveLocalAdapter(ref.read, typeId: null),
        InternalHolder(_recipesFinders)));

final recipesRepositoryProvider =
    Provider<Repository<Recipe>>((ref) => Repository<Recipe>(ref.read));

extension RecipeDataRepositoryX on Repository<Recipe> {
  BaseAdapter<Recipe> get baseAdapter => remoteAdapter as BaseAdapter<Recipe>;
}

extension RecipeRelationshipGraphNodeX on RelationshipGraphNode<Recipe> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map json) => Recipe(
      id: json['_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => RecipeIngredient.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const <RecipeIngredient>[],
      difficulty: json['difficulty'] as String?,
      rating: json['rating'] as int?,
      cost: json['cost'] as int?,
      availabilityMonths: (json['availabilityMonths'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const <int>[],
      servs: json['servs'] as int?,
      estimatedPreparationTime: json['estimatedPreparationTime'] as int?,
      estimatedCookingTime: json['estimatedCookingTime'] as int?,
      imgUrl: json['imgUrl'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      preparation: json['preparation'] as String?,
      recipeUrl: json['recipeUrl'] as String?,
      note: json['note'] as String?,
      insertTimestamp: json['insert_timestamp'] as int?,
      updateTimestamp: json['update_timestamp'] as int?,
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('insert_timestamp', instance.insertTimestamp);
  writeNotNull('update_timestamp', instance.updateTimestamp);
  val['name'] = instance.name;
  writeNotNull('description', instance.description);
  writeNotNull('rating', instance.rating);
  writeNotNull('cost', instance.cost);
  writeNotNull('difficulty', instance.difficulty);
  val['availabilityMonths'] = instance.availabilityMonths;
  writeNotNull('servs', instance.servs);
  writeNotNull('estimatedCookingTime', instance.estimatedCookingTime);
  writeNotNull('estimatedPreparationTime', instance.estimatedPreparationTime);
  val['ingredients'] = instance.ingredients.map((e) => e.toJson()).toList();
  writeNotNull('preparation', instance.preparation);
  writeNotNull('note', instance.note);
  writeNotNull('imgUrl', instance.imgUrl);
  writeNotNull('recipeUrl', instance.recipeUrl);
  val['tags'] = instance.tags;
  return val;
}

RecipeIngredient _$RecipeIngredientFromJson(Map json) => RecipeIngredient(
      ingredientId: json['ingredient'] as String,
      unitOfMeasure: json['unitOfMeasure'] as String?,
      quantity: json['quantity'] ?? 0,
      freezed: json['freezed'] ?? false,
    );

Map<String, dynamic> _$RecipeIngredientToJson(RecipeIngredient instance) {
  final val = <String, dynamic>{
    'ingredient': instance.ingredientId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('quantity', instance.quantity);
  writeNotNull('unitOfMeasure', instance.unitOfMeasure);
  writeNotNull('freezed', instance.freezed);
  return val;
}
