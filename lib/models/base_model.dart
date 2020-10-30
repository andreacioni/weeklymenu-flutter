import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:objectid/objectid.dart';
import 'package:weekly_menu_app/globals/memento.dart';

abstract class BaseModel<T> with ChangeNotifier implements Cloneable<T> {
  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'insert_timestamp')
  int insertTimestamp;

  @JsonKey(name: 'update_timestamp')
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
