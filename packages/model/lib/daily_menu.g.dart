// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_menu.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DailyMenuCWProxy {
  DailyMenu date(Date date);

  DailyMenu idx(String? idx);

  DailyMenu insertTimestamp(int? insertTimestamp);

  DailyMenu meals(Map<Meal, DailyMenuMeal> meals);

  DailyMenu updateTimestamp(int? updateTimestamp);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyMenu(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyMenu(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyMenu call({
    Date? date,
    String? idx,
    int? insertTimestamp,
    Map<Meal, DailyMenuMeal>? meals,
    int? updateTimestamp,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyMenu.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyMenu.copyWith.fieldName(...)`
class _$DailyMenuCWProxyImpl implements _$DailyMenuCWProxy {
  final DailyMenu _value;

  const _$DailyMenuCWProxyImpl(this._value);

  @override
  DailyMenu date(Date date) => this(date: date);

  @override
  DailyMenu idx(String? idx) => this(idx: idx);

  @override
  DailyMenu insertTimestamp(int? insertTimestamp) =>
      this(insertTimestamp: insertTimestamp);

  @override
  DailyMenu meals(Map<Meal, DailyMenuMeal> meals) => this(meals: meals);

  @override
  DailyMenu updateTimestamp(int? updateTimestamp) =>
      this(updateTimestamp: updateTimestamp);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyMenu(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyMenu(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyMenu call({
    Object? date = const $CopyWithPlaceholder(),
    Object? idx = const $CopyWithPlaceholder(),
    Object? insertTimestamp = const $CopyWithPlaceholder(),
    Object? meals = const $CopyWithPlaceholder(),
    Object? updateTimestamp = const $CopyWithPlaceholder(),
  }) {
    return DailyMenu(
      date: date == const $CopyWithPlaceholder() || date == null
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as Date,
      idx: idx == const $CopyWithPlaceholder()
          ? _value.idx
          // ignore: cast_nullable_to_non_nullable
          : idx as String?,
      insertTimestamp: insertTimestamp == const $CopyWithPlaceholder()
          ? _value.insertTimestamp
          // ignore: cast_nullable_to_non_nullable
          : insertTimestamp as int?,
      meals: meals == const $CopyWithPlaceholder() || meals == null
          ? _value.meals
          // ignore: cast_nullable_to_non_nullable
          : meals as Map<Meal, DailyMenuMeal>,
      updateTimestamp: updateTimestamp == const $CopyWithPlaceholder()
          ? _value.updateTimestamp
          // ignore: cast_nullable_to_non_nullable
          : updateTimestamp as int?,
    );
  }
}

extension $DailyMenuCopyWith on DailyMenu {
  /// Returns a callable class that can be used as follows: `instanceOfDailyMenu.copyWith(...)` or like so:`instanceOfDailyMenu.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyMenuCWProxy get copyWith => _$DailyMenuCWProxyImpl(this);
}

abstract class _$DailyMenuMealCWProxy {
  DailyMenuMeal recipeIds(List<String> recipeIds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyMenuMeal(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyMenuMeal(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyMenuMeal call({
    List<String>? recipeIds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDailyMenuMeal.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDailyMenuMeal.copyWith.fieldName(...)`
class _$DailyMenuMealCWProxyImpl implements _$DailyMenuMealCWProxy {
  final DailyMenuMeal _value;

  const _$DailyMenuMealCWProxyImpl(this._value);

  @override
  DailyMenuMeal recipeIds(List<String> recipeIds) => this(recipeIds: recipeIds);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DailyMenuMeal(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DailyMenuMeal(...).copyWith(id: 12, name: "My name")
  /// ````
  DailyMenuMeal call({
    Object? recipeIds = const $CopyWithPlaceholder(),
  }) {
    return DailyMenuMeal(
      recipeIds: recipeIds == const $CopyWithPlaceholder() || recipeIds == null
          ? _value.recipeIds
          // ignore: cast_nullable_to_non_nullable
          : recipeIds as List<String>,
    );
  }
}

extension $DailyMenuMealCopyWith on DailyMenuMeal {
  /// Returns a callable class that can be used as follows: `instanceOfDailyMenuMeal.copyWith(...)` or like so:`instanceOfDailyMenuMeal.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DailyMenuMealCWProxy get copyWith => _$DailyMenuMealCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyMenu _$DailyMenuFromJson(Map json) => DailyMenu(
      idx: json['_id'] as String?,
      date: const DateConverter().fromJson(json['date'] as String),
      meals: (json['meals'] as Map?)?.map(
            (k, e) => MapEntry($enumDecode(_$MealEnumMap, k),
                DailyMenuMeal.fromJson(Map<String, dynamic>.from(e as Map))),
          ) ??
          const {},
      insertTimestamp: json['insert_timestamp'] as int?,
      updateTimestamp: json['update_timestamp'] as int?,
    );

Map<String, dynamic> _$DailyMenuToJson(DailyMenu instance) {
  final val = <String, dynamic>{
    '_id': instance.idx,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('insert_timestamp', instance.insertTimestamp);
  writeNotNull('update_timestamp', instance.updateTimestamp);
  val['date'] = const DateConverter().toJson(instance.date);
  val['meals'] =
      instance.meals.map((k, e) => MapEntry(_$MealEnumMap[k]!, e.toJson()));
  return val;
}

const _$MealEnumMap = {
  Meal.Breakfast: 'Breakfast',
  Meal.Lunch: 'Lunch',
  Meal.Dinner: 'Dinner',
};

DailyMenuMeal _$DailyMenuMealFromJson(Map json) => DailyMenuMeal(
      recipeIds:
          (json['recipes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DailyMenuMealToJson(DailyMenuMeal instance) =>
    <String, dynamic>{
      'recipes': instance.recipeIds,
    };
