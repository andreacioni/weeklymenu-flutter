// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return Recipe(
    id: json['_id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    ingredients: (json['ingredients'] as List)
            ?.map((e) => e == null
                ? null
                : RecipeIngredient.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    difficulty: json['difficulty'] as String,
    rating: json['rating'] as int,
    cost: json['cost'] as int,
    servs: json['servs'] as int,
    estimatedPreparationTime: json['estimatedPreparationTime'] as int,
    estimatedCookingTime: json['estimatedCookingTime'] as int,
    imgUrl: json['imgUrl'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
  )
    ..availabilityMonths =
        (json['availabilityMonths'] as List)?.map((e) => e as int)?.toList()
    ..preparation = json['preparation'] as String
    ..note = json['note'] as String
    ..recipeUrl = json['recipeUrl'] as String;
}

Map<String, dynamic> _$RecipeToJson(Recipe instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('rating', instance.rating);
  writeNotNull('cost', instance.cost);
  writeNotNull('difficulty', instance.difficulty);
  writeNotNull('availabilityMonths', instance.availabilityMonths);
  writeNotNull('servs', instance.servs);
  writeNotNull('estimatedCookingTime', instance.estimatedCookingTime);
  writeNotNull('estimatedPreparationTime', instance.estimatedPreparationTime);
  writeNotNull('ingredients', instance.ingredients);
  writeNotNull('preparation', instance.preparation);
  writeNotNull('note', instance.note);
  writeNotNull('imgUrl', instance.imgUrl);
  writeNotNull('recipeUrl', instance.recipeUrl);
  writeNotNull('tags', instance.tags);
  return val;
}

RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) {
  return RecipeIngredient(
    ingredientId: json['ingredient'] as String,
    quantity: (json['quantity'] as num)?.toDouble(),
    unitOfMeasure: json['unitOfMeasure'] as String,
    freezed: json['freezed'] as bool,
  );
}

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