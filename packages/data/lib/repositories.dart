import 'dart:async';
import 'dart:developer';

import 'package:common/configuration.dart';
import 'package:data/flutter_data/constants.dart';
import 'package:data/flutter_data/ingredient.dart';
import 'package:data/flutter_data/recipe.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/ingredient.dart';
import 'package:model/recipe.dart';
import 'package:common/storage_type.dart';
import 'package:flutter_data/flutter_data.dart' as flutter_data;
import 'main.data.dart' as main;

final repositoryInitializerProvider = FutureProvider<void>((ref) async {
  final cfg = ref.read(bootstrapConfigurationProvider);
  if (cfg.storageType == StorageType.flutterData) {
    await ref.read(main.repositoryInitializerProvider.future);
  }
});

/** has to be updated every time you have a new repository */
final repositoryProviders = Provider<List<Provider<Repository>>>(
    (_) => [recipeRepositoryProvider, ingredientsRepositoryProvider]);

extension RepositoryWidgetRefX on WidgetRef {
  Repository<Ingredient> get ingredients =>
      watch(ingredientsRepositoryProvider);
  Repository<Recipe> get recipes => watch(recipeRepositoryProvider);
}

abstract class Repository<T> {
  FutureOr<void> init();
  FutureOr<void> reload();
  Stream<List<T>> stream();
  Stream<T> streamOne(Object id);
  FutureOr<T> save(T t, {Map<String, dynamic>? params});
  FutureOr<T?> load(Object id);
  FutureOr<List<T>> loadAll({bool remote = true, Map<String, dynamic>? params});
  FutureOr<void> delete(Object id);
  FutureOr<void> clear({bool local = true});
}

// RECIPE

final recipeRepositoryProvider = Provider((ref) {
  final cfg = ref.read(bootstrapConfigurationProvider);
  return RecipeRepository(cfg.storageType, ref: ref, debug: cfg.debug);
});

class RecipeRepository extends Repository<Recipe> {
  late final Repository<Recipe> _repository;

  RecipeRepository(StorageType storageType,
      {ProviderRef? ref, bool debug = false}) {
    if (storageType == StorageType.flutterData) {
      _repository = _FlutterDataRecipeRepository(ref!, debug: debug);
    }
  }

  @override
  FutureOr<void> init() {
    return _repository.init();
  }

  @override
  FutureOr<void> reload() {
    return _repository.reload();
  }

  @override
  Stream<List<Recipe>> stream() {
    return _repository.stream();
  }

  @override
  Stream<Recipe> streamOne(Object id) {
    return _repository.streamOne(id);
  }

  @override
  FutureOr<Recipe?> load(Object id) {
    return _repository.load(id);
  }

  @override
  FutureOr<List<Recipe>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.loadAll(remote: remote, params: params);
  }

  @override
  FutureOr<void> delete(Object id) {
    return _repository.delete(id);
  }

  @override
  FutureOr<Recipe> save(Recipe t, {Map<String, dynamic>? params}) async {
    log("saving: ${t.toJson()}");
    final saved = await _repository.save(t, params: params);
    log("saved: ${t.id}");
    return saved;
  }

  @override
  FutureOr<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

class _FlutterDataRecipeRepository extends Repository<Recipe> {
  late final flutter_data.Repository<FlutterDataRecipe> _repository;
  final bool debug;
  final ProviderRef ref;

  _FlutterDataRecipeRepository(this.ref, {this.debug = false}) {
    _repository = ref.read(flutterDataRecipesRepositoryProvider);
  }

  @override
  void init() {
    _repository.logLevel = debug ? 2 : 0;
  }

  @override
  FutureOr<void> reload() async {
    await _repository.findAll(syncLocal: true);
  }

  @override
  FutureOr<Recipe?> load(Object id) async {
    return await _repository.findOne(id);
  }

  @override
  FutureOr<List<Recipe>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.findAll(remote: remote, params: params);
  }

  @override
  Stream<List<Recipe>> stream() {
    final notifier = ref.flutterDataRecipes.watchAllNotifier();
    return notifier.stream.asyncMap((state) {
      if (state.hasException) {
        throw state.exception!;
      }

      if (state.isLoading && !state.hasModel) {
        return Future.delayed(const Duration(minutes: 1));
      }

      return state.model!;
    });
  }

  @override
  Stream<FlutterDataRecipe> streamOne(Object id) {
    final notifier = ref.flutterDataRecipes.watchOneNotifier(id);
    return notifier.stream.asyncMap((state) {
      if (state.hasException) {
        throw state.exception!;
      }

      if (state.isLoading && !state.hasModel) {
        return Future.delayed(const Duration(minutes: 1));
      }

      return state.model!;
    });
  }

  @override
  FutureOr<void> delete(Object id) async {
    await _repository.delete(id);
  }

  @override
  FutureOr<Recipe> save(Recipe r, {Map<String, dynamic>? params}) async {
    final flutterDataRecipe = FlutterDataRecipe.fromJson(r.toJson());
    return await flutterDataRecipe.save(params: params);
  }

  @override
  FutureOr<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

// INGREDIENTS

final ingredientsRepositoryProvider = Provider((ref) {
  final cfg = ref.read(bootstrapConfigurationProvider);
  return IngredientRepository(cfg.storageType, ref: ref, debug: cfg.debug);
});

class IngredientRepository extends Repository<Ingredient> {
  late final Repository<Ingredient> _repository;

  IngredientRepository(StorageType storageType,
      {ProviderRef? ref, bool debug = false}) {
    if (storageType == StorageType.flutterData) {
      _repository = _FlutterDataIngredientRepository(ref!, debug: debug);
    }
  }

  @override
  void init() {
    _repository.init();
  }

  @override
  FutureOr<void> reload() {
    return _repository.reload();
  }

  @override
  FutureOr<Ingredient?> load(Object id) {
    return _repository.load(id);
  }

  @override
  FutureOr<List<Ingredient>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.loadAll(remote: remote, params: params);
  }

  @override
  Stream<List<Ingredient>> stream() {
    return _repository.stream();
  }

  @override
  Stream<Ingredient> streamOne(Object id) {
    return _repository.streamOne(id);
  }

  @override
  FutureOr<void> delete(Object id) {
    return _repository.delete(id);
  }

  @override
  FutureOr<Ingredient> save(Ingredient t, {Map<String, dynamic>? params}) {
    return _repository.save(t, params: params);
  }

  @override
  FutureOr<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

class _FlutterDataIngredientRepository extends Repository<Ingredient> {
  late final flutter_data.Repository<FlutterDataIngredient> _repository;
  final ProviderRef ref;
  final bool debug;

  _FlutterDataIngredientRepository(this.ref, {this.debug = false}) {
    _repository = ref.read(flutterDataIngredientsRepositoryProvider);
  }

  @override
  void init() {
    _repository.logLevel = debug ? 2 : 0;
  }

  @override
  FutureOr<void> reload() async {
    await _repository.findAll(syncLocal: true);
  }

  @override
  FutureOr<Ingredient?> load(Object id) async {
    return await _repository.findOne(id);
  }

  @override
  FutureOr<List<Ingredient>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.findAll(remote: remote, params: params);
  }

  @override
  Stream<List<FlutterDataIngredient>> stream() {
    final notifier = ref.flutterDataIngredients.watchAllNotifier();
    return notifier.stream.asyncMap((state) {
      if (state.hasException) {
        throw state.exception!;
      }

      if (state.isLoading && !state.hasModel) {
        return Future.delayed(const Duration(minutes: 1));
      }

      return state.model!;
    });
  }

  @override
  Stream<FlutterDataIngredient> streamOne(Object id) {
    final notifier = ref.flutterDataIngredients.watchOneNotifier(id);
    return notifier.stream.asyncMap((state) {
      if (state.hasException) {
        throw state.exception!;
      }

      if (state.isLoading && !state.hasModel) {
        return Future.delayed(const Duration(minutes: 1));
      }

      return state.model!;
    });
  }

  @override
  FutureOr<void> delete(Object id) async {
    await _repository.delete(id);
  }

  @override
  FutureOr<Ingredient> save(Ingredient r,
      {Map<String, dynamic>? params}) async {
    final flutterDataIngredient = FlutterDataIngredient.fromJson(r.toJson());
    return await flutterDataIngredient.save(params: params);
  }

  @override
  FutureOr<void> clear({bool local = true}) {
    return _repository.clear();
  }
}
