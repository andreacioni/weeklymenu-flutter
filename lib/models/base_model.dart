import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:objectid/objectid.dart';
import 'package:weekly_menu_app/globals/memento.dart';

abstract class BaseModel<T> with ChangeNotifier implements Cloneable<T> {
  @JsonKey(name: '_id')
  @HiveField(254)
  String id;

  @JsonKey(name: 'insert_timestamp')
  @HiveField(253)
  int insertTimestamp;

  @JsonKey(name: 'update_timestamp')
  @HiveField(252)
  int updateTimestamp;

  BaseModel({
    this.id,
    this.insertTimestamp,
    this.updateTimestamp,
  }) {
    if (id == null) {
      this.id = ObjectId().hexString;
    }
  }
}
