import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_data/flutter_data.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/globals/memento.dart';
import 'package:weekly_menu_app/services/auth_service.dart';

abstract class BaseModel<T extends DataModel<T>>
    with DataModel<T>
    implements Cloneable<T> {
  @override
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'insert_timestamp', ignore: true)
  final int insertTimestamp;

  @JsonKey(name: 'update_timestamp', ignore: true)
  final int updateTimestamp;

  BaseModel({
    required this.id,
    this.insertTimestamp = 0,
    this.updateTimestamp = 0,
  });
}

mixin BaseAdapter<T extends DataModel<T>> on RemoteAdapter<T> {
  final _providerContainer = ProviderContainer();

  @override
  String get baseUrl => "https://heroku-weeklymenu.herokuapp.com/api/v1/";

  @override
  FutureOr<Map<String, String>> get defaultHeaders async {
    final token = await _providerContainer.read(authServiceProvider).token;
    if (token == null) {
      throw StateError("can't get a valid token");
    }
    final bearerToken = 'Bearer ' + token.jwt;
    return {'Content-Type': 'application/json', 'Authorization': bearerToken};
  }

  @override
  DeserializedData<T> deserialize(Object? data, {String? key}) {
    final json = data as Map<String, dynamic>;
    return super.deserialize(
        json.containsKey('results') ? json['results'] : json,
        key: key);
  }
}
