

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: directives_ordering, top_level_function_literal_block, depend_on_referenced_packages

import 'package:flutter_data/flutter_data.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weekly_menu_app/models/ingredient.dart';
import 'package:weekly_menu_app/models/menu.dart';
import 'package:weekly_menu_app/models/recipe.dart';
import 'package:weekly_menu_app/models/shopping_list.dart';
import 'package:weekly_menu_app/models/user_preferences.dart';

// ignore: prefer_function_declarations_over_variables
ConfigureRepositoryLocalStorage configureRepositoryLocalStorage = ({FutureFn<String>? baseDirFn, List<int>? encryptionKey, LocalStorageClearStrategy? clear}) {
  if (!kIsWeb) {
    baseDirFn ??= () => getApplicationDocumentsDirectory().then((dir) => dir.path);
  } else {
    baseDirFn ??= () => '';
  }
  
  return hiveLocalStorageProvider.overrideWith(
    (ref) => HiveLocalStorage(
      hive: ref.read(hiveProvider),
      baseDirFn: baseDirFn,
      encryptionKey: encryptionKey,
      clear: clear,
    ),
  );
};

final repositoryProviders = <String, Provider<Repository<DataModel>>>{
  'ingredients': ingredientsRepositoryProvider,
'menus': menusRepositoryProvider,
'recipes': recipesRepositoryProvider,
'shopping-lists': shoppingListsRepositoryProvider,
'userPreferences': userPreferencesRepositoryProvider
};

final repositoryInitializerProvider =
  FutureProvider<RepositoryInitializer>((ref) async {
    DataHelpers.setInternalType<Ingredient>('ingredients');
    DataHelpers.setInternalType<Menu>('menus');
    DataHelpers.setInternalType<Recipe>('recipes');
    DataHelpers.setInternalType<ShoppingList>('shopping-lists');
    DataHelpers.setInternalType<UserPreference>('userPreferences');
    final adapters = <String, RemoteAdapter>{'ingredients': ref.watch(internalIngredientsRemoteAdapterProvider), 'menus': ref.watch(internalMenusRemoteAdapterProvider), 'recipes': ref.watch(internalRecipesRemoteAdapterProvider), 'shopping-lists': ref.watch(internalShoppingListsRemoteAdapterProvider), 'userPreferences': ref.watch(internalUserPreferencesRemoteAdapterProvider)};
    final remotes = <String, bool>{'ingredients': true, 'menus': true, 'recipes': true, 'shopping-lists': true, 'userPreferences': true};

    await ref.watch(graphNotifierProvider).initialize();

    // initialize and register
    for (final type in repositoryProviders.keys) {
      final repository = ref.read(repositoryProviders[type]!);
      repository.dispose();
      await repository.initialize(
        remote: remotes[type],
        adapters: adapters,
      );
      internalRepositories[type] = repository;
    }

    return RepositoryInitializer();
});
extension RepositoryWidgetRefX on WidgetRef {
  Repository<Ingredient> get ingredients => watch(ingredientsRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Menu> get menus => watch(menusRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<Recipe> get recipes => watch(recipesRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<ShoppingList> get shoppingLists => watch(shoppingListsRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<UserPreference> get userPreferences => watch(userPreferencesRepositoryProvider)..remoteAdapter.internalWatch = watch;
}

extension RepositoryRefX on Ref {

  Repository<Ingredient> get ingredients => watch(ingredientsRepositoryProvider)..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Menu> get menus => watch(menusRepositoryProvider)..remoteAdapter.internalWatch = watch as Watcher;
  Repository<Recipe> get recipes => watch(recipesRepositoryProvider)..remoteAdapter.internalWatch = watch as Watcher;
  Repository<ShoppingList> get shoppingLists => watch(shoppingListsRepositoryProvider)..remoteAdapter.internalWatch = watch as Watcher;
  Repository<UserPreference> get userPreferences => watch(userPreferencesRepositoryProvider)..remoteAdapter.internalWatch = watch as Watcher;
}