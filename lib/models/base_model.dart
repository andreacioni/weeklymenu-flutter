import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_data/flutter_data.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/globals/memento.dart';
import 'package:weekly_menu_app/services/auth_service.dart';

import '../globals/constants.dart';

abstract class BaseModel<T extends DataModel<T>>
    with DataModel<T>
    implements Cloneable<T> {
  @override
  @JsonKey(name: ID_FIELD)
  final String id;

  @JsonKey(name: INSERT_TIMESTAMP_FIELD)
  final int? insertTimestamp;

  @JsonKey(name: UPDATE_TIMESTAMP_FIELD)
  final int? updateTimestamp;

  BaseModel({
    required this.id,
    this.insertTimestamp,
    this.updateTimestamp,
  });
}

mixin BaseAdapter<T extends DataModel<T>> on RemoteAdapter<T> {
  static const BASE_URL = "https://heroku-weeklymenu.herokuapp.com/api/v1/";
  static const CONNECTION_TIMEOUT = const Duration(seconds: 3);

  final _providerContainer = ProviderContainer();

  @override
  String get baseUrl => BASE_URL;

  @override
  http.Client get httpClient {
    final _httpClient = HttpClient();
    final _ioClient = IOClient(_httpClient);

    // decrease the timeout
    _httpClient.connectionTimeout = CONNECTION_TIMEOUT;
    _httpClient.idleTimeout = CONNECTION_TIMEOUT;

    return _ioClient;
  }

  @override
  DataRequestMethod methodForSave(id, Map<String, dynamic> params) =>
      params['update'] == true ? DataRequestMethod.PUT : DataRequestMethod.POST;

  @override
  String urlForSave(id, Map<String, dynamic> params) =>
      params['update'] == true ? '$type/$id' : type;

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
  Map<String, dynamic> serialize(model) {
    final json = super.serialize(model);
    json.remove(UPDATE_TIMESTAMP_FIELD);
    json.remove(INSERT_TIMESTAMP_FIELD);
    return json;
  }

  @override
  @override
  DeserializedData<T> deserialize(Object? data, {String? key}) {
    final json = data as Map<String, dynamic>;
    return super.deserialize(
        json.containsKey('results') ? json['results'] : json,
        key: key);
  }
}
