// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupermarketSection _$SupermarketSectionFromJson(Map json) => SupermarketSection(
      name: json['name'] as String,
      color: const ColorConverter().fromJson(json['color'] as int?),
    );

Map<String, dynamic> _$SupermarketSectionToJson(SupermarketSection instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('color', const ColorConverter().toJson(instance.color));
  return val;
}

UserPreference _$UserPreferenceFromJson(Map json) => UserPreference(
      id: json['_id'],
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

Map<String, dynamic> _$UserPreferenceToJson(UserPreference instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('insert_timestamp', instance.insertTimestamp);
  writeNotNull('update_timestamp', instance.updateTimestamp);
  writeNotNull('shopping_days', instance.shoppingDays);
  writeNotNull('supermarket_sections',
      instance.supermarketSections?.map((e) => e.toJson()).toList());
  writeNotNull('units_of_measure', instance.unitsOfMeasure);
  return val;
}
