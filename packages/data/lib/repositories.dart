import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:common/configuration.dart';
import 'package:data/flutter_data/constants.dart';
import 'package:data/flutter_data/ingredient.dart';
import 'package:data/flutter_data/menu.dart';
import 'package:data/flutter_data/recipe.dart';
import 'package:data/flutter_data/shopping_list.dart';
import 'package:data/flutter_data/user_preferences.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/ingredient.dart';
import 'package:model/menu.dart';
import 'package:model/recipe.dart';
import 'package:common/storage_type.dart';
import 'package:flutter_data/flutter_data.dart' as flutter_data;
import 'package:model/shopping_list.dart';
import 'package:model/user_preferences.dart';
import 'data.dart';
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
  Repository<ShoppingList> get shoppingLists =>
      watch(shoppingListRepositoryProvider);
  Repository<Menu> get menus => watch(menuRepositoryProvider);
  Repository<UserPreference> get userPreferences =>
      watch(userPreferencesRepositoryProvider);
}

abstract class Repository<T> {
  FutureOr<void> init();
  FutureOr<void> reload();
  Stream<List<T>> stream({Map<String, dynamic>? params});
  Stream<T> streamOne(Object id);
  FutureOr<T> save(T t, {Map<String, dynamic>? params});
  FutureOr<T?> load(Object id);
  FutureOr<List<T>> loadAll({bool remote = true, Map<String, dynamic>? params});
  FutureOr<void> delete(Object id, {Map<String, dynamic>? params});
  FutureOr<void> clear({bool local = true});
}

// Flutter Data - DataState to Stream utility
extension FlutterDataStateStream<T> on DataStateNotifier<T> {
  Stream<T> toStream(ProviderRef ref) async* {
    final state = data;
    if (state.hasException) {
      throw state.exception!;
    }

    if (state.hasModel) {
      yield state.model!;
    }

    await for (final state in stream) {
      if (state.hasException) {
        throw state.exception!;
      }

      if (state.isLoading && !state.hasModel) {
        continue;
      }

      yield state.model!;
    }
  }
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
  Stream<List<Recipe>> stream({Map<String, dynamic>? params}) {
    return _repository.stream(params: params);
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
  FutureOr<void> delete(Object id, {Map<String, dynamic>? params}) {
    return _repository.delete(id, params: params);
  }

  @override
  FutureOr<Recipe> save(Recipe t, {Map<String, dynamic>? params}) async {
    log("saving: ${t.toJson()}");
    final saved = await _repository.save(t, params: params);
    log("saved: ${t.idx}");
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
    _repository.logLevel = debug ? 2 : 0;
  }

  @override
  void init() {}

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
  Stream<List<Recipe>> stream({Map<String, dynamic>? params}) {
    return ref.flutterDataRecipes
        .watchAllNotifier(params: params)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Stream<FlutterDataRecipe> streamOne(Object id) {
    return ref.flutterDataRecipes
        .watchOneNotifier(id)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  FutureOr<void> delete(Object id, {Map<String, dynamic>? params}) async {
    await _repository.delete(id, params: params);
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
  Stream<List<Ingredient>> stream({Map<String, dynamic>? params}) {
    return _repository.stream(params: params);
  }

  @override
  Stream<Ingredient> streamOne(Object id) {
    return _repository.streamOne(id);
  }

  @override
  FutureOr<void> delete(Object id, {Map<String, dynamic>? params}) {
    return _repository.delete(id, params: params);
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
    _repository.logLevel = debug ? 2 : 0;
  }

  @override
  void init() {}

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
  Stream<List<FlutterDataIngredient>> stream({Map<String, dynamic>? params}) {
    return ref.flutterDataIngredients
        .watchAllNotifier(params: params)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Stream<FlutterDataIngredient> streamOne(Object id) {
    return ref.flutterDataIngredients
        .watchOneNotifier(id)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  FutureOr<void> delete(Object id, {Map<String, dynamic>? params}) async {
    await _repository.delete(id, params: params);
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

// SHOPPING LIST

final shoppingListRepositoryProvider = Provider((ref) {
  final cfg = ref.read(bootstrapConfigurationProvider);
  return ShoppingListRepository(cfg.storageType, ref: ref, debug: cfg.debug);
});

class ShoppingListRepository extends Repository<ShoppingList> {
  late final Repository<ShoppingList> _repository;

  ShoppingListRepository(StorageType storageType,
      {ProviderRef? ref, bool debug = false}) {
    if (storageType == StorageType.flutterData) {
      _repository = _FlutterDataShoppingListRepository(ref!, debug: debug);
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
  FutureOr<ShoppingList?> load(Object id) {
    return _repository.load(id);
  }

  @override
  FutureOr<List<ShoppingList>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.loadAll(remote: remote, params: params);
  }

  @override
  Stream<List<ShoppingList>> stream({Map<String, dynamic>? params}) {
    return _repository.stream(params: params);
  }

  @override
  Stream<ShoppingList> streamOne(Object id) {
    return _repository.streamOne(id);
  }

  @override
  FutureOr<void> delete(Object id, {Map<String, dynamic>? params}) {
    return _repository.delete(id, params: params);
  }

  @override
  FutureOr<ShoppingList> save(ShoppingList t, {Map<String, dynamic>? params}) {
    return _repository.save(t, params: params);
  }

  @override
  FutureOr<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

class _FlutterDataShoppingListRepository extends Repository<ShoppingList> {
  late final flutter_data.Repository<FlutterDataShoppingList> _repository;
  final ProviderRef ref;
  final bool debug;

  _FlutterDataShoppingListRepository(this.ref, {this.debug = false}) {
    _repository = ref.read(flutterDataShoppingListsRepositoryProvider);
    _repository.logLevel = debug ? 2 : 0;
  }

  @override
  void init() {}

  @override
  FutureOr<void> reload() async {
    await _repository.findAll(syncLocal: true);
  }

  @override
  FutureOr<ShoppingList?> load(Object id) async {
    return await _repository.findOne(id);
  }

  @override
  FutureOr<List<ShoppingList>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.findAll(remote: remote, params: params);
  }

  @override
  Stream<List<ShoppingList>> stream({Map<String, dynamic>? params}) {
    return ref.flutterDataShoppingLists
        .watchAllNotifier(params: params)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Stream<ShoppingList> streamOne(Object id) {
    return ref.flutterDataShoppingLists
        .watchOneNotifier(id)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  FutureOr<void> delete(Object id, {Map<String, dynamic>? params}) async {
    await _repository.delete(id, params: params);
  }

  @override
  FutureOr<ShoppingList> save(ShoppingList r,
      {Map<String, dynamic>? params}) async {
    final flutterDataIngredient = FlutterDataShoppingList.fromJson(r.toJson());
    return await flutterDataIngredient.save(params: params);
  }

  @override
  FutureOr<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

//USER PREFERENCES

final userPreferencesRepositoryProvider = Provider((ref) {
  final cfg = ref.read(bootstrapConfigurationProvider);
  return UserPreferencesRepository(cfg.storageType, ref: ref, debug: cfg.debug);
});

class UserPreferencesRepository extends Repository<UserPreference> {
  late final Repository<UserPreference> _repository;

  UserPreferencesRepository(StorageType storageType,
      {ProviderRef? ref, bool debug = false}) {
    if (storageType == StorageType.flutterData) {
      _repository = _FlutterDataUserPreferencesRepository(ref!, debug: debug);
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
  FutureOr<UserPreference?> load(Object id) {
    return _repository.load(id);
  }

  @override
  FutureOr<List<UserPreference>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.loadAll(remote: remote, params: params);
  }

  @override
  Stream<List<UserPreference>> stream({Map<String, dynamic>? params}) {
    return _repository.stream(params: params);
  }

  @override
  Stream<UserPreference> streamOne(Object id) {
    return _repository.streamOne(id);
  }

  @override
  FutureOr<void> delete(Object id, {Map<String, dynamic>? params}) {
    return _repository.delete(id, params: params);
  }

  @override
  FutureOr<UserPreference> save(UserPreference t,
      {Map<String, dynamic>? params}) {
    return _repository.save(t, params: params);
  }

  @override
  FutureOr<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

class _FlutterDataUserPreferencesRepository extends Repository<UserPreference> {
  late final flutter_data.Repository<FlutterDataUserPreference> _repository;
  final ProviderRef ref;
  final bool debug;

  _FlutterDataUserPreferencesRepository(this.ref, {this.debug = false}) {
    _repository = ref.read(flutterDataUserPreferencesRepositoryProvider);
    _repository.logLevel = debug ? 2 : 0;
  }

  @override
  void init() {}

  @override
  FutureOr<void> reload() async {
    await _repository.findAll(syncLocal: true);
  }

  @override
  FutureOr<UserPreference?> load(Object id) async {
    return await _repository.findOne(id);
  }

  @override
  FutureOr<List<UserPreference>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.findAll(remote: remote, params: params);
  }

  @override
  Stream<List<UserPreference>> stream({Map<String, dynamic>? params}) {
    return ref.flutterDataUserPreferences
        .watchAllNotifier(params: params)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Stream<UserPreference> streamOne(Object id) {
    return ref.flutterDataUserPreferences
        .watchOneNotifier(id)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  FutureOr<void> delete(Object id, {Map<String, dynamic>? params}) async {
    await _repository.delete(id, params: params);
  }

  @override
  FutureOr<UserPreference> save(UserPreference r,
      {Map<String, dynamic>? params}) async {
    final flutterDataUserPreference =
        FlutterDataUserPreference.fromJson(r.toJson());
    return await flutterDataUserPreference.save(params: params);
  }

  @override
  FutureOr<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

// MENU

final menuRepositoryProvider = Provider((ref) {
  final cfg = ref.read(bootstrapConfigurationProvider);
  return MenuRepository(cfg.storageType, ref: ref, debug: cfg.debug);
});

class MenuRepository extends Repository<Menu> {
  late final Repository<Menu> _repository;

  MenuRepository(StorageType storageType,
      {ProviderRef? ref, bool debug = false}) {
    if (storageType == StorageType.flutterData) {
      _repository = _FlutterDataMenuRepository(ref!, debug: debug);
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
  FutureOr<Menu?> load(Object id) {
    return _repository.load(id);
  }

  @override
  FutureOr<List<Menu>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.loadAll(remote: remote, params: params);
  }

  @override
  Stream<List<Menu>> stream({Map<String, dynamic>? params}) {
    return _repository.stream(params: params);
  }

  @override
  Stream<Menu> streamOne(Object id) {
    return _repository.streamOne(id);
  }

  @override
  FutureOr<void> delete(Object id, {Map<String, dynamic>? params}) {
    return _repository.delete(id, params: params);
  }

  @override
  FutureOr<Menu> save(Menu t, {Map<String, dynamic>? params}) {
    return _repository.save(t, params: params);
  }

  @override
  FutureOr<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

class _FlutterDataMenuRepository extends Repository<Menu> {
  late final flutter_data.Repository<FlutterDataMenu> _repository;
  final ProviderRef ref;
  final bool debug;

  _FlutterDataMenuRepository(this.ref, {this.debug = false}) {
    _repository = ref.read(flutterDataMenusRepositoryProvider);
    _repository.logLevel = debug ? 2 : 0;
  }

  @override
  void init() {}

  @override
  FutureOr<void> reload() async {
    await _repository.findAll(syncLocal: true);
  }

  @override
  FutureOr<Menu?> load(Object id) async {
    return await _repository.findOne(id);
  }

  @override
  FutureOr<List<Menu>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.findAll(remote: remote, params: params);
  }

  @override
  Stream<List<Menu>> stream({Map<String, dynamic>? params}) {
    return ref.flutterDataMenus
        .watchAllNotifier(params: params)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Stream<Menu> streamOne(Object id) {
    return ref.flutterDataMenus
        .watchOneNotifier(id)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  FutureOr<void> delete(Object id, {Map<String, dynamic>? params}) async {
    await _repository.delete(id, params: params);
  }

  @override
  FutureOr<Menu> save(Menu r, {Map<String, dynamic>? params}) async {
    final flutterDataMenu = FlutterDataMenu.fromJson(r.toJson());
    return await flutterDataMenu.save(params: params);
  }

  @override
  FutureOr<void> clear({bool local = true}) {
    return _repository.clear();
  }
}
