import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/globals/memento.dart';

abstract class BaseModel<T> with ChangeNotifier implements Cloneable<T> {
  @JsonKey(name: 'offline_id')
  String id;

  @JsonKey(name: 'insert_timestamp')
  String _insertTimestamp;

  @JsonKey(name: 'update_timestamp')
  String _updateTimestamp;

  BaseModel(this.id);

  String get insertTimestamp => _insertTimestamp;

  String get updateTimestamp => _updateTimestamp;
}
