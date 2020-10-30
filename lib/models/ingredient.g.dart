// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return Ingredient(
    id: json['_id'] as String,
    name: json['name'] as String,
  )
    ..insertTimestamp = json['insert_timestamp'] as int
    ..updateTimestamp = json['update_timestamp'] as int;
}

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'insert_timestamp': instance.insertTimestamp,
      'update_timestamp': instance.updateTimestamp,
      'name': instance.name,
    };
