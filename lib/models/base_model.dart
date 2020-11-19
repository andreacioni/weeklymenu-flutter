import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_data/flutter_data.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:objectid/objectid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekly_menu_app/globals/constants.dart';
import 'package:weekly_menu_app/globals/memento.dart';
import 'package:weekly_menu_app/providers/rest_provider.dart';

import 'auth_token.dart';

abstract class BaseModel<T extends DataModel<T>> extends Equatable
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

  List<Object> get props => [id, insertTimestamp, updateTimestamp];
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

  void tryLogin(RestProvider restProvider) async {
    JWTToken jwt;
    final sharedPreferences = await SharedPreferences.getInstance();

    try {
      if ((jwt = tryUseOldToken(sharedPreferences)) != null) {
        restProvider.updateToken(jwt);
        //goToHomepage(context);
        return;
      } else {
        log.e("Can't login with previous token");
      }
    } catch (e) {
      log.w("Invalid token saved in shared preference", e);
    }

    try {
      if ((jwt = await tryUseCredentials(restProvider, sharedPreferences)) !=
          null) {
        restProvider.updateToken(jwt);
        //goToHomepage(context);
        return;
      } else {
        log.e("Can't login with saved credentials");
      }
    } catch (e) {
      log.w("Invalid credentials saved in shared preference", e);
    }

    //goToLogin(context);
  }

  JWTToken tryUseOldToken(SharedPreferences sharedPreferences) {
    final token = sharedPreferences
        .getString(SharedPreferencesKeys.tokenSharedPreferencesKey);

    if (token != null) {
      JWTToken jwt = JWTToken.fromBase64Json(token);

      if (!jwt.isValid()) {
        log.w("Old token is not valid anymore");
        return null;
      }

      return jwt;
    } else {
      log.i("No token saved previusly");
    }

    return null;
  }

  Future<JWTToken> tryUseCredentials(
      RestProvider restProvider, SharedPreferences sharedPreferences) async {
    final username = sharedPreferences
        .getString(SharedPreferencesKeys.emailSharedPreferencesKey);
    final password = sharedPreferences
        .getString(SharedPreferencesKeys.passwordSharedPreferencesKey);

    if (password != null && username != null) {
      final authReponse = await restProvider.login(username, password);
      return JWTToken.fromBase64Json(
          AuthToken.fromJson(authReponse).accessToken);
    }

    return null;
  }
}
