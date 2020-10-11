import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:weekly_menu_app/globals/memento.dart';

abstract class BaseModel<T> with ChangeNotifier implements Cloneable<T> {
  @JsonKey(name: 'offline_id')
  String id;

  @JsonKey(name: '_id')
  @Deprecated(
      "Do not use this ID inside the application, it could be null if the resource is not avaialble in the server")
  String onlineId;

  @JsonKey(name: 'insert_timestamp')
  int insertTimestamp;

  @JsonKey(name: 'update_timestamp')
  int updateTimestamp;

  BaseModel({
    String id,
    this.onlineId,
    this.insertTimestamp,
    this.updateTimestamp,
  }) {
    if (id == null) {
      id = Uuid().v4();
    }
  }
}
