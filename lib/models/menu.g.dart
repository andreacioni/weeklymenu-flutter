// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuAdapter extends TypeAdapter<Menu> {
  @override
  final int typeId = 2;

  @override
  Menu read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Menu(
      date: fields[1] as Date,
      meal: fields[2] as Meal,
    )
      ..id = fields[254] as String
      ..insertTimestamp = fields[253] as int
      ..updateTimestamp = fields[252] as int;
  }

  @override
  void write(BinaryWriter writer, Menu obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.meal)
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
      other is MenuAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) {
  return Menu(
    id: json['_id'] as String,
    date: Menu.dateFromJson(json['date'] as String),
    meal: _$enumDecodeNullable(_$MealEnumMap, json['meal']),
    recipes: (json['recipes'] as List)?.map((e) => e as String)?.toList() ?? [],
  )
    ..insertTimestamp = json['insert_timestamp'] as int
    ..updateTimestamp = json['update_timestamp'] as int;
}

Map<String, dynamic> _$MenuToJson(Menu instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
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
