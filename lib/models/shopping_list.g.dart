// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingList _$ShoppingListFromJson(Map<String, dynamic> json) {
  return ShoppingList(
    json['offline_id'] as String,
    insertTimestamp: json['insert_timestamp'] as int,
    updateTimestamp: json['update_timestamp'] as int,
    items: (json['items'] as List)
            ?.map((e) => e == null
                ? null
                : ShoppingListItem.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    name: json['name'] as String,
  )..onlineId = json['onlineId'] as String;
}

Map<String, dynamic> _$ShoppingListToJson(ShoppingList instance) {
  final val = <String, dynamic>{
    'onlineId': instance.onlineId,
    'offline_id': instance.offlineId,
    'insert_timestamp': instance.insertTimestamp,
    'update_timestamp': instance.updateTimestamp,
    'items': instance.items?.map((e) => e?.toJson())?.toList(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  return val;
}

ShoppingListItem _$ShoppingListItemFromJson(Map<String, dynamic> json) {
  return ShoppingListItem(
    item: json['item'] as String,
    supermarketSection: json['supermarketSection'] as String,
    checked: json['checked'] as bool,
    quantity: (json['quantity'] as num)?.toDouble(),
    unitOfMeasure: json['unitOfMeasure'] as String,
    listPosition: json['listPosition'] as int,
  );
}

Map<String, dynamic> _$ShoppingListItemToJson(ShoppingListItem instance) {
  final val = <String, dynamic>{
    'item': instance.item,
    'checked': instance.checked,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('quantity', instance.quantity);
  writeNotNull('unitOfMeasure', instance.unitOfMeasure);
  writeNotNull('supermarketSection', instance.supermarketSection);
  writeNotNull('listPosition', instance.listPosition);
  return val;
}
