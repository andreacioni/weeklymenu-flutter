// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShoppingListCWProxy {
  ShoppingList id(Object? id);

  ShoppingList insertTimestamp(int? insertTimestamp);

  ShoppingList items(List<ShoppingListItem> items);

  ShoppingList name(String? name);

  ShoppingList updateTimestamp(int? updateTimestamp);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShoppingList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShoppingList(...).copyWith(id: 12, name: "My name")
  /// ````
  ShoppingList call({
    Object? id,
    int? insertTimestamp,
    List<ShoppingListItem>? items,
    String? name,
    int? updateTimestamp,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShoppingList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShoppingList.copyWith.fieldName(...)`
class _$ShoppingListCWProxyImpl implements _$ShoppingListCWProxy {
  final ShoppingList _value;

  const _$ShoppingListCWProxyImpl(this._value);

  @override
  ShoppingList id(Object? id) => this(id: id);

  @override
  ShoppingList insertTimestamp(int? insertTimestamp) =>
      this(insertTimestamp: insertTimestamp);

  @override
  ShoppingList items(List<ShoppingListItem> items) => this(items: items);

  @override
  ShoppingList name(String? name) => this(name: name);

  @override
  ShoppingList updateTimestamp(int? updateTimestamp) =>
      this(updateTimestamp: updateTimestamp);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShoppingList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShoppingList(...).copyWith(id: 12, name: "My name")
  /// ````
  ShoppingList call({
    Object? id = const $CopyWithPlaceholder(),
    Object? insertTimestamp = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? updateTimestamp = const $CopyWithPlaceholder(),
  }) {
    return ShoppingList(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as Object?,
      insertTimestamp: insertTimestamp == const $CopyWithPlaceholder()
          ? _value.insertTimestamp
          // ignore: cast_nullable_to_non_nullable
          : insertTimestamp as int?,
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<ShoppingListItem>,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      updateTimestamp: updateTimestamp == const $CopyWithPlaceholder()
          ? _value.updateTimestamp
          // ignore: cast_nullable_to_non_nullable
          : updateTimestamp as int?,
    );
  }
}

extension $ShoppingListCopyWith on ShoppingList {
  /// Returns a callable class that can be used as follows: `instanceOfShoppingList.copyWith(...)` or like so:`instanceOfShoppingList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ShoppingListCWProxy get copyWith => _$ShoppingListCWProxyImpl(this);
}

abstract class _$ShoppingListItemCWProxy {
  ShoppingListItem checked(bool checked);

  ShoppingListItem itemName(String itemName);

  ShoppingListItem listPosition(int? listPosition);

  ShoppingListItem quantity(double? quantity);

  ShoppingListItem supermarketSectionName(String? supermarketSectionName);

  ShoppingListItem unitOfMeasure(String? unitOfMeasure);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShoppingListItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShoppingListItem(...).copyWith(id: 12, name: "My name")
  /// ````
  ShoppingListItem call({
    bool? checked,
    String? itemName,
    int? listPosition,
    double? quantity,
    String? supermarketSectionName,
    String? unitOfMeasure,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShoppingListItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShoppingListItem.copyWith.fieldName(...)`
class _$ShoppingListItemCWProxyImpl implements _$ShoppingListItemCWProxy {
  final ShoppingListItem _value;

  const _$ShoppingListItemCWProxyImpl(this._value);

  @override
  ShoppingListItem checked(bool checked) => this(checked: checked);

  @override
  ShoppingListItem itemName(String itemName) => this(itemName: itemName);

  @override
  ShoppingListItem listPosition(int? listPosition) =>
      this(listPosition: listPosition);

  @override
  ShoppingListItem quantity(double? quantity) => this(quantity: quantity);

  @override
  ShoppingListItem supermarketSectionName(String? supermarketSectionName) =>
      this(supermarketSectionName: supermarketSectionName);

  @override
  ShoppingListItem unitOfMeasure(String? unitOfMeasure) =>
      this(unitOfMeasure: unitOfMeasure);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShoppingListItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShoppingListItem(...).copyWith(id: 12, name: "My name")
  /// ````
  ShoppingListItem call({
    Object? checked = const $CopyWithPlaceholder(),
    Object? itemName = const $CopyWithPlaceholder(),
    Object? listPosition = const $CopyWithPlaceholder(),
    Object? quantity = const $CopyWithPlaceholder(),
    Object? supermarketSectionName = const $CopyWithPlaceholder(),
    Object? unitOfMeasure = const $CopyWithPlaceholder(),
  }) {
    return ShoppingListItem(
      checked: checked == const $CopyWithPlaceholder() || checked == null
          ? _value.checked
          // ignore: cast_nullable_to_non_nullable
          : checked as bool,
      itemName: itemName == const $CopyWithPlaceholder() || itemName == null
          ? _value.itemName
          // ignore: cast_nullable_to_non_nullable
          : itemName as String,
      listPosition: listPosition == const $CopyWithPlaceholder()
          ? _value.listPosition
          // ignore: cast_nullable_to_non_nullable
          : listPosition as int?,
      quantity: quantity == const $CopyWithPlaceholder()
          ? _value.quantity
          // ignore: cast_nullable_to_non_nullable
          : quantity as double?,
      supermarketSectionName:
          supermarketSectionName == const $CopyWithPlaceholder()
              ? _value.supermarketSectionName
              // ignore: cast_nullable_to_non_nullable
              : supermarketSectionName as String?,
      unitOfMeasure: unitOfMeasure == const $CopyWithPlaceholder()
          ? _value.unitOfMeasure
          // ignore: cast_nullable_to_non_nullable
          : unitOfMeasure as String?,
    );
  }
}

extension $ShoppingListItemCopyWith on ShoppingListItem {
  /// Returns a callable class that can be used as follows: `instanceOfShoppingListItem.copyWith(...)` or like so:`instanceOfShoppingListItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ShoppingListItemCWProxy get copyWith => _$ShoppingListItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingList _$ShoppingListFromJson(Map json) => ShoppingList(
      id: json['_id'],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ShoppingListItem.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      name: json['name'] as String?,
      insertTimestamp: json['insert_timestamp'] as int?,
      updateTimestamp: json['update_timestamp'] as int?,
    );

Map<String, dynamic> _$ShoppingListToJson(ShoppingList instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('insert_timestamp', instance.insertTimestamp);
  writeNotNull('update_timestamp', instance.updateTimestamp);
  val['items'] = instance.items.map((e) => e.toJson()).toList();
  writeNotNull('name', instance.name);
  return val;
}

ShoppingListItem _$ShoppingListItemFromJson(Map json) => ShoppingListItem(
      itemName: json['name'] as String,
      supermarketSectionName: json['supermarketSectionName'] as String?,
      checked: json['checked'] as bool? ?? false,
      quantity: (json['quantity'] as num?)?.toDouble(),
      unitOfMeasure: json['unitOfMeasure'] as String?,
      listPosition: json['listPosition'] as int?,
    );

Map<String, dynamic> _$ShoppingListItemToJson(ShoppingListItem instance) {
  final val = <String, dynamic>{
    'name': instance.itemName,
    'checked': instance.checked,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('quantity', instance.quantity);
  writeNotNull('unitOfMeasure', instance.unitOfMeasure);
  writeNotNull('supermarketSectionName', instance.supermarketSectionName);
  writeNotNull('listPosition', instance.listPosition);
  return val;
}
