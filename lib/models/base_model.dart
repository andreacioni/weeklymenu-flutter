import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_data/flutter_data.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:objectid/objectid.dart';
import 'package:weekly_menu_app/globals/memento.dart';

abstract class BaseModel<T extends DataModel<T>>
    with DataModel<T>, ChangeNotifier
    implements Cloneable<T> {
  @override
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'insert_timestamp', ignore: true)
  int insertTimestamp;

  @JsonKey(name: 'update_timestamp', ignore: true)
  int updateTimestamp;

  BaseModel({
    this.id,
    this.insertTimestamp,
    this.updateTimestamp,
  });
}

mixin BaseAdapter<T extends DataModel<T>> on RemoteAdapter<T> {
  @override
  String get baseUrl => "https://heroku-weeklymenu.herokuapp.com/api/v1/";

  @override
  FutureOr<Map<String, String>> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MDI1MzQwNDcsIm5iZiI6MTYwMjUzNDA0NywianRpIjoiNjE3ZjRiNTYtNzg2Ny00Mzg4LWE1ZTAtMDYxZjc4N2JhMTg1IiwiZXhwIjoyNjAyNTM0OTQ3LCJpZGVudGl0eSI6ImNpb25pQGZsdXRvLmNvbSIsImZyZXNoIjpmYWxzZSwidHlwZSI6ImFjY2VzcyJ9.GQv-m0crSn4_CgdeemzYH6u9afSmM6TobYb-mDappZI'
      };

  @override
  DeserializedData<T, DataModel<dynamic>> deserialize(data,
      {String key, bool init}) {
    final json = data as Map<String, dynamic>;
    return super
        .deserialize(json.containsKey('results') ? json['results'] : json,
            //key: type,
            init: init);
  }
}
