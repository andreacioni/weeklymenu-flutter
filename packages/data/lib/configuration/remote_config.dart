import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:common/log.dart';

final remoteConfigProvider = Provider((_) => WeeklyMenuRemoteConfig._());

class WeeklyMenuRemoteValues {
  static const INGREDIENT_PARSER_VERSION = "ingredient_parser_version";
  static const API_TIMEOUT_MILLIS = "api_timeout_ms";
  static const API_BASE_PATH = "api_base_path";
}

class WeeklyMenuRemoteConfig {
  static const Map<String, Object> _defaults = {
    WeeklyMenuRemoteValues.INGREDIENT_PARSER_VERSION: 0,
    WeeklyMenuRemoteValues.API_TIMEOUT_MILLIS: 3000,
    WeeklyMenuRemoteValues.API_BASE_PATH: "https://weeklymenu.fly.dev/api/v1"
  };
  static const _fetchTimeout = Duration(minutes: 1);
  static const _minimumFetchInterval = Duration(hours: 1);

  final remoteConfig = FirebaseRemoteConfig.instance;

  WeeklyMenuRemoteConfig._();

  Future<void> initialize() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: _fetchTimeout,
      minimumFetchInterval: _minimumFetchInterval,
    ));
    await remoteConfig.setDefaults(_defaults);

    try {
      final activate = await remoteConfig.fetchAndActivate();
      if (activate) {
        logWarn("remote config activate failed!");
      }
    } catch (e, st) {
      logWarn("remote config activate failed!", e, st);
    }
  }

  Future<void> reload() async {
    try {
      return await remoteConfig.fetch();
    } catch (e, st) {
      logWarn("failed to reload remote config", e, st);
    }
  }

  int getInt(String key) {
    return remoteConfig.getInt(key);
  }

  String getString(String key) {
    return remoteConfig.getString(key);
  }

  void logCurrentConfiguration() {
    log("remote config is: ${remoteConfig.getAll().map((key, value) => MapEntry(key, value.asString()))}");
  }
}
