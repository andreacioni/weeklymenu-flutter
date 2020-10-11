// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return Ingredient(
    BaseModel.idFromJson(json['offline_id']),
    insertTimestamp: json['insert_timestamp'] as int,
    updateTimestamp: json['update_timestamp'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'offline_id': BaseModel.idToJson(instance.id),
      'insert_timestamp': instance.insertTimestamp,
      'update_timestamp': instance.updateTimestamp,
      'name': instance.name,
    };
