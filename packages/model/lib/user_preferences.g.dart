// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupermarketSection _$SupermarketSectionFromJson(Map<String, dynamic> json) =>
    SupermarketSection(
      name: json['name'] as String,
      color: const ColorConverter().fromJson(json['color'] as int?),
    );

Map<String, dynamic> _$SupermarketSectionToJson(SupermarketSection instance) =>
    <String, dynamic>{
      'name': instance.name,
      'color': const ColorConverter().toJson(instance.color),
    };

UserPreference _$UserPreferenceFromJson(Map json) => UserPreference(
      id: json['_id'] as String,
      insertTimestamp: json['insert_timestamp'] as int?,
      updateTimestamp: json['update_timestamp'] as int?,
      shoppingDays: (json['shopping_days'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      supermarketSections: (json['supermarket_sections'] as List<dynamic>?)
          ?.map((e) =>
              SupermarketSection.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      unitsOfMeasure: (json['units_of_measure'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [
            'pcs',
            'g',
            'Kg',
            'gr',
            'cup',
            'tsp',
            'tbs',
            'L',
            'ml',
            'dl',
            'cl',
            'm',
            'cm',
            'mm',
            'glass',
            'lb',
            'oz',
            'pt',
            'gl',
            'qt'
          ],
    );

Map<String, dynamic> _$UserPreferenceToJson(UserPreference instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'insert_timestamp': instance.insertTimestamp,
      'update_timestamp': instance.updateTimestamp,
      'shopping_days': instance.shoppingDays,
      'supermarket_sections':
          instance.supermarketSections?.map((e) => e.toJson()).toList(),
      'units_of_measure': instance.unitsOfMeasure,
    };
