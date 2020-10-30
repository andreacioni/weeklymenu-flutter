// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

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

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, non_constant_identifier_names

mixin $MenuLocalAdapter on LocalAdapter<Menu> {
  @override
  Map<String, Map<String, Object>> relationshipsFor([Menu model]) => {};

  @override
  Menu deserialize(map) {
    for (final key in relationshipsFor().keys) {
      map[key] = {
        '_': [map[key], !map.containsKey(key)],
      };
    }
    return Menu.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model) => model.toJson();
}

// ignore: must_be_immutable
class $MenuHiveLocalAdapter = HiveLocalAdapter<Menu> with $MenuLocalAdapter;

class $MenuRemoteAdapter = RemoteAdapter<Menu> with MyJSONServerAdapter;

//

final menuLocalAdapterProvider = RiverpodAlias.provider<LocalAdapter<Menu>>(
    (ref) => $MenuHiveLocalAdapter(
        ref.read(hiveLocalStorageProvider), ref.read(graphProvider)));

final menuRemoteAdapterProvider = RiverpodAlias.provider<RemoteAdapter<Menu>>(
    (ref) => $MenuRemoteAdapter(ref.read(menuLocalAdapterProvider)));

final menuRepositoryProvider =
    RiverpodAlias.provider<Repository<Menu>>((ref) => Repository<Menu>(ref));

extension MenuX on Menu {
  /// Initializes "fresh" models (i.e. manually instantiated) to use
  /// [save], [delete] and so on.
  ///
  /// Pass:
  ///  - A `BuildContext` if using Flutter with Riverpod or Provider
  ///  - Nothing if using Flutter with GetIt
  ///  - A Riverpod `ProviderContainer` if using pure Dart
  ///  - Its own [Repository<Menu>]
  Menu init(context) {
    final repository = context is Repository<Menu>
        ? context
        : internalLocatorFn(menuRepositoryProvider, context);
    return repository.internalAdapter.initializeModel(this, save: true) as Menu;
  }
}
