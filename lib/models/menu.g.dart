// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) {
  return Menu(
    json['offline_id'] as String,
    insertTimestamp: json['insert_timestamp'] as int,
    updateTimestamp: json['update_timestamp'] as int,
    date: Menu.dateFromJson(json['date'] as String),
    meal: _$enumDecodeNullable(_$MealEnumMap, json['meal']),
    recipes: (json['recipes'] as List)?.map((e) => e as String)?.toList() ?? [],
  )..onlineId = json['onlineId'] as String;
}

Map<String, dynamic> _$MenuToJson(Menu instance) {
  final val = <String, dynamic>{
    'onlineId': instance.onlineId,
    'offline_id': instance.offlineId,
    'insert_timestamp': instance.insertTimestamp,
    'update_timestamp': instance.updateTimestamp,
    'date': Menu.dateToJson(instance.date),
    'meal': _$MealEnumMap[instance.meal],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('recipes', instance.recipes);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$MealEnumMap = {
  Meal.Breakfast: 'Breakfast',
  Meal.Lunch: 'Lunch',
  Meal.Dinner: 'Dinner',
};
