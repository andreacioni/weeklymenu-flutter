// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShoppingListAdapter extends TypeAdapter<ShoppingList> {
  @override
  final int typeId = 4;

  @override
  ShoppingList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingList(
      items: (fields[1] as List)?.cast<ShoppingListItem>(),
      name: fields[2] as String,
    )
      ..id = fields[254] as String
      ..insertTimestamp = fields[253] as int
      ..updateTimestamp = fields[252] as int;
  }

  @override
  void write(BinaryWriter writer, ShoppingList obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.items)
      ..writeByte(2)
      ..write(obj.name)
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
      other is ShoppingListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShoppingListItemAdapter extends TypeAdapter<ShoppingListItem> {
  @override
  final int typeId = 6;

  @override
  ShoppingListItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingListItem(
      item: fields[1] as String,
      supermarketSection: fields[5] as String,
      checked: fields[2] as bool,
      quantity: fields[3] as double,
      unitOfMeasure: fields[4] as String,
      listPosition: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ShoppingListItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.item)
      ..writeByte(2)
      ..write(obj.checked)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.unitOfMeasure)
      ..writeByte(5)
      ..write(obj.supermarketSection)
      ..writeByte(6)
      ..write(obj.listPosition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingListItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingList _$ShoppingListFromJson(Map<String, dynamic> json) {
  return ShoppingList(
    id: json['_id'] as String,
    items: (json['items'] as List)
            ?.map((e) => e == null
                ? null
                : ShoppingListItem.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    name: json['name'] as String,
  )
    ..insertTimestamp = json['insert_timestamp'] as int
    ..updateTimestamp = json['update_timestamp'] as int;
}

Map<String, dynamic> _$ShoppingListToJson(ShoppingList instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
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
