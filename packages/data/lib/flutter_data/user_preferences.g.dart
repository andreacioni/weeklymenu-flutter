// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $FlutterDataUserPreferenceLocalAdapter
    on LocalAdapter<FlutterDataUserPreference> {
  static final Map<String, RelationshipMeta>
      _kFlutterDataUserPreferenceRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kFlutterDataUserPreferenceRelationshipMetas;

  @override
  FlutterDataUserPreference deserialize(map) {
    map = transformDeserialize(map);
    return FlutterDataUserPreference.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _flutterDataUserPreferencesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $FlutterDataUserPreferenceHiveLocalAdapter = HiveLocalAdapter<
    FlutterDataUserPreference> with $FlutterDataUserPreferenceLocalAdapter;

class $FlutterDataUserPreferenceRemoteAdapter = RemoteAdapter<
        FlutterDataUserPreference>
    with
        BaseAdapter<FlutterDataUserPreference>,
        UserPreferencesAdapter<FlutterDataUserPreference>;

final internalFlutterDataUserPreferencesRemoteAdapterProvider =
    Provider<RemoteAdapter<FlutterDataUserPreference>>((ref) =>
        $FlutterDataUserPreferenceRemoteAdapter(
            $FlutterDataUserPreferenceHiveLocalAdapter(ref),
            InternalHolder(_flutterDataUserPreferencesFinders)));

final flutterDataUserPreferencesRepositoryProvider =
    Provider<Repository<FlutterDataUserPreference>>(
        (ref) => Repository<FlutterDataUserPreference>(ref));

extension FlutterDataUserPreferenceDataRepositoryX
    on Repository<FlutterDataUserPreference> {
  BaseAdapter<FlutterDataUserPreference> get baseAdapter =>
      remoteAdapter as BaseAdapter<FlutterDataUserPreference>;
  UserPreferencesAdapter<FlutterDataUserPreference>
      get userPreferencesAdapter =>
          remoteAdapter as UserPreferencesAdapter<FlutterDataUserPreference>;
}

extension FlutterDataUserPreferenceRelationshipGraphNodeX
    on RelationshipGraphNode<FlutterDataUserPreference> {}
