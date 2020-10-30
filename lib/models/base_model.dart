import 'package:flutter/foundation.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hive/hive.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:objectid/objectid.dart';
import 'package:weekly_menu_app/globals/memento.dart';

abstract class BaseModel<T extends DataModel<T>>
    with DataModel<T>, ChangeNotifier
    implements Cloneable<T> {
  @override
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'insert_timestamp')
  int insertTimestamp;

  @JsonKey(name: 'update_timestamp')
  int updateTimestamp;

  BaseModel({
    this.id,
    this.insertTimestamp,
    this.updateTimestamp,
  });
}
