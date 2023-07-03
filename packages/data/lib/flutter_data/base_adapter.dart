import 'dart:async';
import 'dart:io';
import 'package:common/constants.dart';
import 'package:common/date.dart';
import 'package:data/auth/auth_service.dart';
import 'package:data/configuration/remote_config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_data/flutter_data.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:model/auth_token.dart';
import 'package:model/base_model.dart';

mixin BaseAdapter<T extends DataModelMixin<T>> on RemoteAdapter<T> {
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
      _httpClient.connectionTimeout = Duration(
          milliseconds: ref
              .read(remoteConfigProvider)
              .getInt(WeeklyMenuRemoteValues.API_TIMEOUT_MILLIS));
      _httpClient.idleTimeout = Duration(
          milliseconds: ref
              .read(remoteConfigProvider)
              .getInt(WeeklyMenuRemoteValues.API_TIMEOUT_MILLIS));
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
    //final token = await ref.read(tokenServiceProvider).token;
    final token = await ref.read(tokenServiceProvider).token;
    if (token == null || !token.isValid) {
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
