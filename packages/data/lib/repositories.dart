import 'dart:async';
import 'dart:developer';

import 'package:common/configuration.dart';
import 'package:data/flutter_data/daily_menu.dart';
import 'package:data/flutter_data/ingredient.dart';
import 'package:data/flutter_data/recipe.dart';
import 'package:data/flutter_data/shopping_list.dart';
import 'package:data/flutter_data/user_preferences.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/daily_menu.dart';
import 'package:model/ingredient.dart';
import 'package:model/recipe.dart';
import 'package:common/storage_type.dart';
import 'package:flutter_data/flutter_data.dart' as flutter_data;
import 'package:model/shopping_list.dart';
import 'package:model/user_preferences.dart';
import 'main.data.dart' as main;

final repositoryInitializerProvider = FutureProvider<void>((ref) async {
  final cfg = ref.read(bootstrapConfigurationProvider);
  if (cfg.storageType == StorageType.flutterData) {
    await ref.read(main.repositoryInitializerProvider.future);
  }
});

/** has to be updated every time you have a new repository */
final repositoryProviders = Provider<List<Provider<Repository>>>((_) => [
      recipeRepositoryProvider,
      ingredientsRepositoryProvider,
      dailyMenuRepositoryProvider,
      userPreferencesRepositoryProvider,
      shoppingListRepositoryProvider,
      shoppingListItemRepositoryProvider,
      externalRecipeRepositoryProvider,
    ]);

extension RepositoryWidgetWidgetRefX on WidgetRef {
  Repository<Ingredient> get ingredients =>
      watch(ingredientsRepositoryProvider);
  Repository<Recipe> get recipes => watch(recipeRepositoryProvider);
  Repository<ShoppingList> get shoppingLists =>
      watch(shoppingListRepositoryProvider);
  Repository<ShoppingList> get shoppingListItems =>
      watch(shoppingListRepositoryProvider);
  Repository<DailyMenu> get menus => watch(dailyMenuRepositoryProvider);
  Repository<UserPreference> get userPreferences =>
      watch(userPreferencesRepositoryProvider);
  Repository<ExternalRecipe> get externalRecipes =>
      watch(externalRecipeRepositoryProvider);
  Repository<DailyMenu> get dailyMenu => watch(dailyMenuRepositoryProvider);
}

extension RepositoryWidgetRefX on Ref {
  Repository<Ingredient> get ingredients =>
      watch(ingredientsRepositoryProvider);
  Repository<Recipe> get recipes => watch(recipeRepositoryProvider);
  Repository<ShoppingList> get shoppingLists =>
      watch(shoppingListRepositoryProvider);
  Repository<ShoppingList> get shoppingListItems =>
      watch(shoppingListRepositoryProvider);
  Repository<DailyMenu> get dailyMenu => watch(dailyMenuRepositoryProvider);
  Repository<UserPreference> get userPreferences =>
      watch(userPreferencesRepositoryProvider);
  Repository<ExternalRecipe> get externalRecipes =>
      watch(externalRecipeRepositoryProvider);
}

abstract class Repository<T> {
  Future<void> init();
  Future<void> reload({Map<String, dynamic>? params});
  Stream<List<T>> stream({Map<String, dynamic>? params});
  Stream<T> streamOne(String id);
  Future<T> save(T t, {Map<String, dynamic>? params});
  Future<T?> load(String id);
  Future<List<T>> loadAll({bool remote = true, Map<String, dynamic>? params});
  Future<void> delete(String id, {Map<String, dynamic>? params});
  Future<void> clear({bool local = true});
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
  Future<void> init() {
    return _repository.init();
  }

  @override
  Future<void> reload({Map<String, dynamic>? params}) {
    return _repository.reload();
  }

  @override
  Stream<List<Recipe>> stream({Map<String, dynamic>? params}) {
    return _repository.stream(params: params);
  }

  @override
  Stream<Recipe> streamOne(String id) {
    return _repository.streamOne(id);
  }

  @override
  Future<Recipe?> load(String id) {
    return _repository.load(id);
  }

  @override
  Future<List<Recipe>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.loadAll(remote: remote, params: params);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) {
    return _repository.delete(id, params: params);
  }

  @override
  Future<Recipe> save(Recipe t, {Map<String, dynamic>? params}) async {
    log("saving: ${t.toJson()}");
    final saved = await _repository.save(t, params: params);
    log("saved: ${t.idx}");
    return saved;
  }

  @override
  Future<void> clear({bool local = true}) {
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
  Future<void> init() async {}

  @override
  Future<void> reload({Map<String, dynamic>? params}) async {
    await _repository.findAll(syncLocal: true);
  }

  @override
  Future<Recipe?> load(String id) async {
    return await _repository.findOne(id);
  }

  @override
  Future<List<Recipe>> loadAll(
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
  Stream<FlutterDataRecipe> streamOne(String id) {
    return ref.flutterDataRecipes
        .watchOneNotifier(id)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) async {
    await _repository.delete(id, params: params);

    /* try {
      //all the menus containing the recipes have to be refreshed
      ref.read(menuRepositoryProvider).reload();

      return;
    } catch (e, st) {
      logError("failed to refresh menu repository ", e, st);
    }
 */
    /* log("manually clearing menus");
    for (final m
        in await ref.read(menuRepositoryProvider).loadAll(remote: false)) {
      try {
        final newMenu = m.removeRecipeById(id as String);
        ref.read(menuRepositoryProvider).save(newMenu);
      } catch (e, st) {
        logError("failed to refresh menu repository ", e, st);
      }
    }*/
  }

  @override
  Future<Recipe> save(Recipe r, {Map<String, dynamic>? params}) async {
    final flutterDataRecipe = FlutterDataRecipe.fromJson(r.toJson());
    return await flutterDataRecipe.save(params: params);
  }

  @override
  Future<void> clear({bool local = true}) {
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
  Future<void> init() async {
    _repository.init();
  }

  @override
  Future<void> reload({Map<String, dynamic>? params}) {
    return _repository.reload();
  }

  @override
  Future<Ingredient?> load(String id) {
    return _repository.load(id);
  }

  @override
  Future<List<Ingredient>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.loadAll(remote: remote, params: params);
  }

  @override
  Stream<List<Ingredient>> stream({Map<String, dynamic>? params}) {
    return _repository.stream(params: params);
  }

  @override
  Stream<Ingredient> streamOne(String id) {
    return _repository.streamOne(id);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) {
    return _repository.delete(id, params: params);
  }

  @override
  Future<Ingredient> save(Ingredient t, {Map<String, dynamic>? params}) {
    return _repository.save(t, params: params);
  }

  @override
  Future<void> clear({bool local = true}) {
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
  Future<void> init() async {}

  @override
  Future<void> reload({Map<String, dynamic>? params}) async {
    await _repository.findAll(syncLocal: true);
  }

  @override
  Future<Ingredient?> load(String id) async {
    return await _repository.findOne(id);
  }

  @override
  Future<List<Ingredient>> loadAll(
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
  Stream<FlutterDataIngredient> streamOne(String id) {
    return ref.flutterDataIngredients
        .watchOneNotifier(id)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) async {
    await _repository.delete(id, params: params);
  }

  @override
  Future<Ingredient> save(Ingredient r, {Map<String, dynamic>? params}) async {
    final flutterDataIngredient = FlutterDataIngredient.fromJson(r.toJson());
    return await flutterDataIngredient.save(params: params);
  }

  @override
  Future<void> clear({bool local = true}) {
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
  Future<void> init() async {
    _repository.init();
  }

  @override
  Future<void> reload({Map<String, dynamic>? params}) {
    return _repository.reload();
  }

  @override
  Future<ShoppingList?> load(String id) {
    return _repository.load(id);
  }

  @override
  Future<List<ShoppingList>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.loadAll(remote: remote, params: params);
  }

  @override
  Stream<List<ShoppingList>> stream({Map<String, dynamic>? params}) {
    return _repository.stream(params: params);
  }

  @override
  Stream<ShoppingList> streamOne(String id) {
    return _repository.streamOne(id);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) {
    return _repository.delete(id, params: params);
  }

  @override
  Future<ShoppingList> save(ShoppingList t, {Map<String, dynamic>? params}) {
    return _repository.save(t, params: params);
  }

  @override
  Future<void> clear({bool local = true}) {
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
  Future<void> init() async {}

  @override
  Future<void> reload({Map<String, dynamic>? params}) async {
    await _repository.findAll(syncLocal: true);
  }

  @override
  Future<ShoppingList?> load(String id) async {
    return await _repository.findOne(id);
  }

  @override
  Future<List<ShoppingList>> loadAll(
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
  Stream<ShoppingList> streamOne(String id) {
    return ref.flutterDataShoppingLists
        .watchOneNotifier(id)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) async {
    await _repository.delete(id, params: params);
  }

  @override
  Future<ShoppingList> save(ShoppingList r,
      {Map<String, dynamic>? params}) async {
    final flutterDataIngredient = FlutterDataShoppingList.fromJson(r.toJson());
    return await flutterDataIngredient.save(params: params);
  }

  @override
  Future<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

// SHOPPING LIST ITEMS

final shoppingListItemRepositoryProvider = Provider((ref) {
  final cfg = ref.read(bootstrapConfigurationProvider);
  return ShoppingListItemRepository(cfg.storageType,
      ref: ref, debug: cfg.debug);
});

class ShoppingListItemRepository extends Repository<ShoppingListItem> {
  late final Repository<ShoppingListItem> _repository;

  ShoppingListItemRepository(StorageType storageType,
      {ProviderRef? ref, bool debug = false}) {
    if (storageType == StorageType.flutterData) {
      _repository = _FlutterDataShoppingListItemRepository(ref!, debug: debug);
    }
  }

  @override
  Future<void> init() async {
    _repository.init();
  }

  @override
  Future<void> reload({Map<String, dynamic>? params}) {
    return _repository.reload(params: params);
  }

  @override
  Future<ShoppingListItem?> load(String id) {
    return _repository.load(id);
  }

  @override
  Future<List<ShoppingListItem>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.loadAll(remote: remote, params: params);
  }

  @override
  Stream<List<ShoppingListItem>> stream({Map<String, dynamic>? params}) {
    return _repository.stream(params: params);
  }

  @override
  Stream<ShoppingListItem> streamOne(String id) {
    return _repository.streamOne(id);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) {
    return _repository.delete(id, params: params);
  }

  @override
  Future<ShoppingListItem> save(ShoppingListItem t,
      {Map<String, dynamic>? params}) {
    return _repository.save(t, params: params);
  }

  @override
  Future<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

class _FlutterDataShoppingListItemRepository
    extends Repository<ShoppingListItem> {
  late final flutter_data.Repository<FlutterDataShoppingListItem> _repository;
  final ProviderRef ref;
  final bool debug;

  _FlutterDataShoppingListItemRepository(this.ref, {this.debug = false}) {
    _repository = ref.read(flutterDataShoppingListItemsRepositoryProvider);
    _repository.logLevel = debug ? 2 : 0;
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> reload({Map<String, dynamic>? params}) async {
    await _repository.findAll(syncLocal: true, params: params);
  }

  @override
  Future<ShoppingListItem?> load(String id) async {
    return await _repository.findOne(id);
  }

  @override
  Future<List<ShoppingListItem>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.findAll(remote: remote, params: params);
  }

  @override
  Stream<List<ShoppingListItem>> stream({Map<String, dynamic>? params}) {
    return ref.flutterDataShoppingListItems
        .watchAllNotifier(params: params)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Stream<ShoppingListItem> streamOne(String id) {
    return ref.flutterDataShoppingListItems
        .watchOneNotifier(id)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) async {
    await _repository.delete(id, params: params);
  }

  @override
  Future<ShoppingListItem> save(ShoppingListItem r,
      {Map<String, dynamic>? params}) async {
    final item = FlutterDataShoppingListItem.fromJson(r.toJson());
    return await item.save(params: params);
  }

  @override
  Future<void> clear({bool local = true}) {
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
  Future<void> init() async {
    _repository.init();
  }

  @override
  Future<void> reload({Map<String, dynamic>? params}) {
    return _repository.reload();
  }

  @override
  Future<UserPreference?> load(String id) {
    return _repository.load(id);
  }

  @override
  Future<List<UserPreference>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.loadAll(remote: remote, params: params);
  }

  @override
  Stream<List<UserPreference>> stream({Map<String, dynamic>? params}) {
    return _repository.stream(params: params);
  }

  @override
  Stream<UserPreference> streamOne(String id) {
    return _repository.streamOne(id);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) {
    return _repository.delete(id, params: params);
  }

  @override
  Future<UserPreference> save(UserPreference t,
      {Map<String, dynamic>? params}) {
    return _repository.save(t, params: params);
  }

  @override
  Future<void> clear({bool local = true}) {
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
  Future<void> init() async {}

  @override
  Future<void> reload({Map<String, dynamic>? params}) async {
    await _repository.findAll(syncLocal: true);
  }

  @override
  Future<UserPreference?> load(String id) async {
    return await _repository.findOne(id);
  }

  @override
  Future<List<UserPreference>> loadAll(
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
  Stream<UserPreference> streamOne(String id) {
    return ref.flutterDataUserPreferences
        .watchOneNotifier(id)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) async {
    await _repository.delete(id, params: params);
  }

  @override
  Future<UserPreference> save(UserPreference r,
      {Map<String, dynamic>? params}) async {
    final flutterDataUserPreference =
        FlutterDataUserPreference.fromJson(r.toJson());
    return await flutterDataUserPreference.save(params: params);
  }

  @override
  Future<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

// MENU

final dailyMenuRepositoryProvider = Provider((ref) {
  final cfg = ref.read(bootstrapConfigurationProvider);
  return DailyMenuRepository(cfg.storageType, ref: ref, debug: cfg.debug);
});

class DailyMenuRepository extends Repository<DailyMenu> {
  late final Repository<DailyMenu> _repository;

  DailyMenuRepository(StorageType storageType,
      {ProviderRef? ref, bool debug = false}) {
    if (storageType == StorageType.flutterData) {
      _repository = _FlutterDataMenuRepository(ref!, debug: debug);
    }
  }

  @override
  Future<void> init() async {
    _repository.init();
  }

  @override
  Future<void> reload({Map<String, dynamic>? params}) {
    return _repository.reload();
  }

  @override
  Future<DailyMenu?> load(String id) {
    return _repository.load(id);
  }

  @override
  Future<List<DailyMenu>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.loadAll(remote: remote, params: params);
  }

  @override
  Stream<List<DailyMenu>> stream({Map<String, dynamic>? params}) {
    return _repository.stream(params: params);
  }

  @override
  Stream<DailyMenu> streamOne(String id) {
    return _repository.streamOne(id);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) {
    return _repository.delete(id, params: params);
  }

  @override
  Future<DailyMenu> save(DailyMenu t, {Map<String, dynamic>? params}) {
    return _repository.save(t, params: params);
  }

  @override
  Future<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

class _FlutterDataMenuRepository extends Repository<DailyMenu> {
  late final flutter_data.Repository<FlutterDataDailyMenu> _repository;
  final ProviderRef ref;
  final bool debug;

  _FlutterDataMenuRepository(this.ref, {this.debug = false}) {
    _repository = ref.read(flutterDataDailyMenusRepositoryProvider);
    _repository.logLevel = debug ? 2 : 0;
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> reload({Map<String, dynamic>? params}) async {
    await _repository.findAll(syncLocal: true);
  }

  @override
  Future<DailyMenu?> load(String id) async {
    return await _repository.findOne(id);
  }

  @override
  Future<List<DailyMenu>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.findAll(remote: remote, params: params);
  }

  @override
  Stream<List<DailyMenu>> stream({Map<String, dynamic>? params}) {
    return ref.flutterDataDailyMenus
        .watchAllNotifier(params: params)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Stream<DailyMenu> streamOne(String id) {
    return ref.flutterDataDailyMenus
        .watchOneNotifier(id)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) async {
    await _repository.delete(id, params: params);
  }

  @override
  Future<DailyMenu> save(DailyMenu r, {Map<String, dynamic>? params}) async {
    final flutterDataMenu = FlutterDataDailyMenu.fromJson(r.toJson());
    return await flutterDataMenu.save(params: params);
  }

  @override
  Future<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

// EXTERNAL RECIPE

final externalRecipeRepositoryProvider = Provider((ref) {
  final cfg = ref.read(bootstrapConfigurationProvider);
  return ExternalRecipeRepository(cfg.storageType, ref: ref, debug: cfg.debug);
});

class ExternalRecipeRepository extends Repository<ExternalRecipe> {
  late final Repository<ExternalRecipe> _repository;

  ExternalRecipeRepository(StorageType storageType,
      {ProviderRef? ref, bool debug = false}) {
    if (storageType == StorageType.flutterData) {
      _repository = _FlutterDataExternalRecipeRepository(ref!, debug: debug);
    }
  }

  @override
  Future<void> init() async {
    _repository.init();
  }

  @override
  Future<void> reload({Map<String, dynamic>? params}) {
    return _repository.reload();
  }

  @override
  Future<ExternalRecipe?> load(String id) {
    return _repository.load(id);
  }

  @override
  Future<List<ExternalRecipe>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.loadAll(remote: remote, params: params);
  }

  @override
  Stream<List<ExternalRecipe>> stream({Map<String, dynamic>? params}) {
    return _repository.stream(params: params);
  }

  @override
  Stream<ExternalRecipe> streamOne(String id) {
    return _repository.streamOne(id);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) {
    throw UnimplementedError("delete is not available on an external recipe");
  }

  @override
  Future<ExternalRecipe> save(ExternalRecipe t,
      {Map<String, dynamic>? params}) {
    throw UnimplementedError("save is not available on an external recipe");
  }

  @override
  Future<void> clear({bool local = true}) {
    return _repository.clear();
  }
}

class _FlutterDataExternalRecipeRepository extends Repository<ExternalRecipe> {
  late final flutter_data.Repository<FlutterDataExternalRecipe> _repository;
  final ProviderRef ref;
  final bool debug;

  _FlutterDataExternalRecipeRepository(this.ref, {this.debug = false}) {
    _repository = ref.read(flutterDataExternalRecipesRepositoryProvider);
    _repository.logLevel = debug ? 2 : 0;
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> reload({Map<String, dynamic>? params}) async {
    await _repository.findAll(syncLocal: true);
  }

  @override
  Future<ExternalRecipe?> load(String id) async {
    return await _repository.findOne(id);
  }

  @override
  Future<List<ExternalRecipe>> loadAll(
      {bool remote = true, Map<String, dynamic>? params}) {
    return _repository.findAll(remote: remote, params: params);
  }

  @override
  Stream<List<ExternalRecipe>> stream({Map<String, dynamic>? params}) {
    return ref.flutterDataExternalRecipes
        .watchAllNotifier(params: params)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Stream<ExternalRecipe> streamOne(String id) {
    return ref.flutterDataExternalRecipes
        .watchOneNotifier(id)
        .toStream(ref)
        //elements are never null here
        .map((e) => e!);
  }

  @override
  Future<void> delete(String id, {Map<String, dynamic>? params}) {
    throw UnimplementedError("delete is not available on an external recipe");
  }

  @override
  Future<ExternalRecipe> save(ExternalRecipe t,
      {Map<String, dynamic>? params}) {
    throw UnimplementedError("save is not available on an external recipe");
  }

  @override
  Future<void> clear({bool local = true}) {
    return _repository.clear();
  }
}
