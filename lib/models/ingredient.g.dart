// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return Ingredient(
    json['offline_id'] as String,
    insertTimestamp: json['insert_timestamp'] as int,
    updateTimestamp: json['update_timestamp'] as int,
    name: json['name'] as String,
  )..onlineId = json['onlineId'] as String;
}

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'onlineId': instance.onlineId,
      'offline_id': instance.offlineId,
      'insert_timestamp': instance.insertTimestamp,
      'update_timestamp': instance.updateTimestamp,
      'name': instance.name,
    };
