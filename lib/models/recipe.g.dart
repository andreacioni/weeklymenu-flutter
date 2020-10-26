// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 3;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      name: fields[1] as String,
      description: fields[2] as String,
      ingredients: (fields[10] as List)?.cast<RecipeIngredient>(),
      difficulty: fields[5] as String,
      rating: fields[3] as int,
      cost: fields[4] as int,
      availabilityMonths: (fields[6] as List)?.cast<int>(),
      servs: fields[7] as int,
      estimatedPreparationTime: fields[9] as int,
      estimatedCookingTime: fields[8] as int,
      imgUrl: fields[13] as String,
      tags: (fields[15] as List)?.cast<String>(),
      preparation: fields[11] as String,
      recipeUrl: fields[14] as String,
      note: fields[12] as String,
      owner: fields[16] as String,
    )
      ..id = fields[254] as String
      ..insertTimestamp = fields[253] as int
      ..updateTimestamp = fields[252] as int;
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(19)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.cost)
      ..writeByte(5)
      ..write(obj.difficulty)
      ..writeByte(6)
      ..write(obj.availabilityMonths)
      ..writeByte(7)
      ..write(obj.servs)
      ..writeByte(8)
      ..write(obj.estimatedCookingTime)
      ..writeByte(9)
      ..write(obj.estimatedPreparationTime)
      ..writeByte(10)
      ..write(obj.ingredients)
      ..writeByte(11)
      ..write(obj.preparation)
      ..writeByte(12)
      ..write(obj.note)
      ..writeByte(13)
      ..write(obj.imgUrl)
      ..writeByte(14)
      ..write(obj.recipeUrl)
      ..writeByte(15)
      ..write(obj.tags)
      ..writeByte(16)
      ..write(obj.owner)
      ..writeByte(254)
      ..write(obj.id)
      ..writeByte(253)
      ..write(obj.insertTimestamp)
      ..writeByte(252)
      ..write(obj.updateTimestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecipeIngredientAdapter extends TypeAdapter<RecipeIngredient> {
  @override
  final int typeId = 5;

  @override
  RecipeIngredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeIngredient();
  }

  @override
  void write(BinaryWriter writer, RecipeIngredient obj) {
    writer..writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeIngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
    availabilityMonths:
        (json['availabilityMonths'] as List)?.map((e) => e as int)?.toList(),
    servs: json['servs'] as int,
    estimatedPreparationTime: json['estimatedPreparationTime'] as int,
    estimatedCookingTime: json['estimatedCookingTime'] as int,
    imgUrl: json['imgUrl'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    preparation: json['preparation'] as String,
    recipeUrl: json['recipeUrl'] as String,
    note: json['note'] as String,
  )
    ..insertTimestamp = json['insert_timestamp'] as int
    ..updateTimestamp = json['update_timestamp'] as int;
}

Map<String, dynamic> _$RecipeToJson(Recipe instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
    'insert_timestamp': instance.insertTimestamp,
    'update_timestamp': instance.updateTimestamp,
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
  writeNotNull(
      'ingredients', instance.ingredients?.map((e) => e?.toJson())?.toList());
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
