import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/io_client.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';

import '../globals/memento.dart';
import '../globals/constants.dart';
import '../providers/authentication.dart';
import 'auth_token.dart';

abstract class BaseModel<T extends DataModel<T>> extends DataModel<T>
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
  static const CONNECTION_TIMEOUT = const Duration(seconds: 3);

  @override
  String get baseUrl => API_BASE_PATH;

  @override
  FutureOr<Map<String, dynamic>> get defaultParams => {'per_page': 1000};

  @override
  http.Client get httpClient {
    if (kIsWeb) {
      return http.Client();
    } else {
      final _httpClient = HttpClient();
      final _ioClient = IOClient(_httpClient);
      // decrease the timeout
      _httpClient.connectionTimeout = CONNECTION_TIMEOUT;
      _httpClient.idleTimeout = CONNECTION_TIMEOUT;
      return _ioClient;
    }
  }

  @override
  DataRequestMethod methodForSave(id, Map<String, dynamic> params) =>
      params[UPDATE_PARAM] == true
          ? DataRequestMethod.PUT
          : DataRequestMethod.POST;

  @override
  String urlForSave(id, Map<String, dynamic> params) =>
      params[UPDATE_PARAM] == true ? '$type/$id' : type;

  @override
  FutureOr<Map<String, String>> get defaultHeaders async {
    final token = await read(tokenServiceProvider).token;

    if (token == null) {
      throw StateError("can't get a valid token");
    }

    final bearerToken = 'Bearer ' + token.jwt;
    return {'Content-Type': 'application/json', 'Authorization': bearerToken};
  }

  @override
  Future<Map<String, dynamic>> serialize(model,
      {bool withRelationships = false}) async {
    final json = await super.serialize(model);
    json.remove(UPDATE_TIMESTAMP_FIELD);
    json.remove(INSERT_TIMESTAMP_FIELD);
    return json;
  }

  @override
  Future<DeserializedData<T>> deserialize(Object? data) async {
    if (data is Map) {
      final json = data as Map<String, dynamic>;
      return await super.deserialize(
        json.containsKey('results') ? json['results'] : json,
      );
    } else if (data is List) {
      return await super.deserialize(data);
    } else {
      throw 'response data is an unexpected type: $data';
    }
  }
}
