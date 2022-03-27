import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weekly_menu_app/models/base_model.dart';
import 'package:weekly_menu_app/models/shopping_list.dart';
import 'package:weekly_menu_app/services/auth_service.dart';
import '../globals/http.dart';
import '../models/shopping_list.dart';
import '../models/base_model.dart';

final isarProvider = FutureProvider((ref) async => await Isar.open(
    schemas: [ShoppingListSchema],
    directory: (await getApplicationDocumentsDirectory()).path));

abstract class BaseRepository<T extends BaseModel<T>> {
  Stream<List<T>> watchAll();
  Future<List<T>> findAll();
  Future<List<T>> updateSince(int timestamp);
  Future<T> save(T v);
}

abstract class Repository<T extends BaseModel<T>> extends BaseRepository<T> {
  final RemoteRepository<T> _remote;
  @protected
  final LocalRepository<T> local;

  Repository(this._remote, this.local);

  Future<void> sync() async {}

  @override
  Future<T> save(T v) {
    return local.save(v);
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
  Future<List<T>> updateSince(int timestamp) {
    throw UnimplementedError("'updateSince' is not callable on repository");
  }
}

abstract class LocalRepository<T extends BaseModel<T>>
    extends BaseRepository<T> {
  @protected
  final IsarCollection<T> collection;
  LocalRepository(this.collection);

  @override
  Stream<List<T>> watchAll() {
    return collection.where().watch();
  }

  @override
  Future<List<T>> findAll() {
    return collection.where().findAll();
  }

  @override
  Future<T> save(T v) async {
    return await collection.isar.writeTxn((_) async {
      final id = await collection.put(v);
      return (await collection.get(id))!;
    });
  }

  @override
  Future<List<T>> updateSince(int timestamp) async {
    return collection.buildQuery(whereClauses: [
      WhereClause(
        indexName: 'updateTimestamp',
        lower: [timestamp],
        includeLower: false,
      )
    ]).findAll() as List<T>;
  }
}

abstract class RemoteRepository<T extends BaseModel<T>>
    extends BaseRepository<T> {
  final AuthService _authService;
  final Dio _dio;

  RemoteRepository(this._authService, this._dio);

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
  Future<List<T>> findAll() {
    throw UnimplementedError('findAll not needed, use updatedSince');
  }

  @override
  Future<T> save(T v) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<List<T>> updateSince(int timestamp) async {
    final collectionName = T.runtimeType.toString();
    final response = await _dio.get('$BASE_URL/$collectionName');

    final json = response.data as Map<String, dynamic>;
    if (!json.containsKey('results')) {
      throw StateError("'results' not in the response body");
    }

    final list = json['results'] as List<Map<String, dynamic>>;
    if (T is ShoppingList) {
      return list.map((j) => ShoppingList.fromJson(j) as T).toList();
    }

    throw StateError('T ($T) is not recognized');
  }
}
