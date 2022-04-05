import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:objectid/objectid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekly_menu_app/models/base_model.dart';
import 'package:weekly_menu_app/models/shopping_list.dart';
import 'package:weekly_menu_app/repository/syncronize.dart';
import 'package:weekly_menu_app/services/auth_service.dart';
import '../globals/http.dart';
import '../models/shopping_list.dart';
import '../models/base_model.dart';

final isarProvider = FutureProvider((ref) async => await Isar.open(
    schemas: [ShoppingListSchema],
    directory: (await getApplicationDocumentsDirectory()).path));

abstract class Syncronizable<T extends BaseModel2<T>> {
  Future<List<Changeset<T>>> pull(int timestamp);
  void push(List<Changeset<T>> items);
}

abstract class BaseRepository<T extends BaseModel2<T>>
    extends Syncronizable<T> {
  Stream<List<T>> watchAll();
  Stream<T> watchOne(String id);

  Future<List<T>> findAll();
  Future<T?> findOne(String id);
  Future<T> save(T v);
}

abstract class Repository<T extends BaseModel2<T>> extends BaseRepository<T> {
  static const LOCAL_TS_SK = 'localTimestampWatermark';
  static const REMOTE_TS_SK = 'localTimestampWatermark';

  final RemoteRepository<T> _remote;
  @protected
  final LocalRepository<T> local;

  SharedPreferences sharedPreferences;

  Repository(this._remote, this.local, {required this.sharedPreferences});

  Future<void> sync() async {
    final remoteTs = sharedPreferences.getInt(REMOTE_TS_SK) ?? 0;
    final localTs = sharedPreferences.getInt(LOCAL_TS_SK) ?? 0;

    final remoteUpdates = await _remote.pull(remoteTs);
    final localUpdates = await local.pull(localTs);

    // group local + remote update together and than create a map
    // that contains for each entry a list of the changeset associated to
    // a specific id
    final updates = [...localUpdates, ...remoteUpdates]
        .fold<Map<String, List<Changeset<T>>>>({}, _changesetFold);

    // merge all the changeset list to a single changeset, merging if
    // necessary the two objects. On field conflict the most recent change wins.
    // Note that the lists HAVE TO contain at most 2 elements (one remote
    //changeset and one local)
    final merged =
        updates.values.fold<Map<String, Changeset<T>>>({}, _changesetMerge);

    final outgoingChangeset = merged.values
        .where((e) =>
            e.source == ChangesetSource.LOCAL ||
            e.source == ChangesetSource.MERGE)
        .toList();

    final incomingChangeset = merged.values
        .where((e) =>
            e.source == ChangesetSource.REMOTE ||
            e.source == ChangesetSource.MERGE)
        .toList();

    (outgoingChangeset..sort()).forEach((e) async {
      assert(e.localTimestamp != null);
      await _remote.save(e.value);
      sharedPreferences.setInt(LOCAL_TS_SK, e.localTimestamp!);
    });

    (incomingChangeset..sort()).forEach((e) async {
      assert(e.remoteTimestamp != null);
      await local.save(e.value);
      sharedPreferences.setInt(LOCAL_TS_SK, e.remoteTimestamp!);
    });
  }

  Map<String, List<Changeset<T>>> _changesetFold(
      Map<String, List<Changeset<T>>> previousValue, Changeset<T> element) {
    if (previousValue[element.id] == null) {
      previousValue[element.id!] = [];
    }

    previousValue[element.id]!.add(element);

    return previousValue;
  }

  Map<String, Changeset<T>> _changesetMerge(
      Map<String, Changeset<T>> previousValue, List<Changeset<T>> element) {
    if (element.isEmpty) return previousValue;

    final id = element[0].id!;

    if (element.length > 1) {
      previousValue[id] = element[0].merge(element[1]);
    } else {
      previousValue[id] = element[0];
    }

    return previousValue;
  }

  @override
  Future<T> save(T v) {
    if (v.id == null) {
      v = (v as dynamic).copyWith(
        id: ObjectId().hexString,
        insertTimestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
      );
    }
    v = (v as dynamic).copyWith(
      updateTimestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
    );

    return local.save(v);
  }

  @override
  Stream<T> watchOne(String id) {
    return local.watchOne(id);
  }

  @override
  Future<T?> findOne(String id) {
    return local.findOne(id);
  }

  @override
  Future<List<T>> findAll() {
    return local.findAll();
  }

  @override
  Stream<List<T>> watchAll() {
    return local.watchAll();
  }

  @override
  Future<List<Changeset<T>>> pull(int timestamp) {
    throw UnimplementedError("'pull' can't be called on repository");
  }

  @override
  void push(List<Changeset<T>> items) {
    throw UnimplementedError("'push' can't be called on repository");
  }
}

abstract class LocalRepository<T extends BaseModel2<T>>
    extends BaseRepository<T> {
  @protected
  final IsarCollection<T> collection;
  LocalRepository(this.collection);

  @override
  Stream<List<T>> watchAll() {
    return collection.where().watch();
  }

  @override
  Stream<T> watchOne(String id) {
    throw UnimplementedError('not yet implemented');
  }

  @override
  Future<T?> findOne(String id) {
    return collection
        .buildQuery<T>(
          filter: FilterGroup.and([
            FilterCondition(
              property: 'id',
              type: ConditionType.eq,
              caseSensitive: true,
              value: id,
            )
          ]),
        )
        .findFirst();
  }

  @override
  Future<List<T>> findAll() {
    return collection.where().findAll();
  }

  @override
  Future<T> save(T v) async {
    return await collection.isar.writeTxn((_) async {
      v = (v as dynamic).copyWith(
          updateTimestamp: DateTime.now().toUtc().millisecondsSinceEpoch);
      final id = await collection.put(v);
      return (await collection.get(id))!;
    });
  }

  @override
  Future<List<Changeset<T>>> pull(int timestamp) async {
    return (await collection.buildQuery(whereClauses: [
      WhereClause(
        indexName: 'updateTimestamp',
        lower: [timestamp],
        includeLower: false,
      )
    ]).findAll())
        .map((e) => Changeset<T>.local(e))
        .toList();
  }

  @override
  void push(List<Changeset<T>> items) {
    // TODO: implement push
  }
}

abstract class RemoteRepository<T extends BaseModel2<T>>
    extends BaseRepository<T> {
  static const REMOTE_TIMESTAMP_HEADER = '';
  final AuthService _authService;
  final Dio _dio;

  RemoteRepository(this._authService, this._dio);

  String get collection => T.runtimeType.toString();

  FutureOr<Map<String, String>> get defaultHeaders async {
    final token = await _authService.token;
    if (token == null) {
      throw StateError("can't get a valid token");
    }
    final bearerToken = 'Bearer ' + token.jwt;
    return {'Content-Type': 'application/json', 'Authorization': bearerToken};
  }

  @override
  Stream<List<T>> watchAll() {
    throw UnimplementedError('watchAll not implemented for remote repository');
  }

  @override
  Stream<T> watchOne(String id) {
    throw UnimplementedError('not yet implemented');
  }

  @override
  Future<List<T>> findAll() {
    throw UnimplementedError('findAll not needed, use updatedSince');
  }

  @override
  Future<T?> findOne(String id) {
    throw UnimplementedError('findOne not implemented on remote');
  }

  @override
  Future<T> save(T v) async {
    Response<Map<String, dynamic>> response;
    if (v.id == null) {
      //create
      response = await _dio.post('$BASE_URL/$collection', data: _serialize(v));
    } else {
      //update
      response =
          await _dio.put('$BASE_URL/$collection/${v.id}', data: _serialize(v));
    }

    return _deserialize(response.data!);
  }

  @override
  void push(List<Changeset<T>> items) {}

  @override
  Future<List<Changeset<T>>> pull(int timestamp) async {
    final response = await _dio.get('$BASE_URL/$collection',
        queryParameters: {'update_timestamp': timestamp});

    final json = response.data as Map<String, dynamic>;
    if (!json.containsKey('results')) {
      throw StateError("'results' not in the response body");
    }

    final list = json['results'] as List<Map<String, dynamic>>;
    return list
        .map((j) => Changeset(_deserialize(j), source: ChangesetSource.REMOTE))
        .toList();
  }

  Map<String, dynamic> _serialize(T v) {
    if (T is ShoppingList) {
      return (v as ShoppingList).toJson();
    }

    throw StateError("can't serialize T ($T) is not recognized");
  }

  T _deserialize(Map<String, dynamic> v) {
    if (T is ShoppingList) {
      return ShoppingList.fromJson(v) as T;
    }

    throw StateError('cant deserialize T, ($T) is not recognized');
  }
}
