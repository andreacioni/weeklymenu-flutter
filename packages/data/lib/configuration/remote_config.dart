import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final remoteConfigProvider = Provider((_) => WeeklyMenuRemoteConfig._());

class WeeklyMenuRemoteValues {
  static const INGREDIENT_PARSER_VERSION = "ingredient_parser_version";
  static const API_TIMEOUT_MILLIS = "api_timeout_ms";
}

class WeeklyMenuRemoteConfig {
  static const Map<String, Object> _defaults = {
    WeeklyMenuRemoteValues.INGREDIENT_PARSER_VERSION: 0,
    WeeklyMenuRemoteValues.API_TIMEOUT_MILLIS: 3000
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
  }

  int getInt(String key) {
    return remoteConfig.getInt(key);
  }
}
