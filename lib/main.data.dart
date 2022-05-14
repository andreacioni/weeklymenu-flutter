

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: directives_ordering, top_level_function_literal_block

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
ConfigureRepositoryLocalStorage configureRepositoryLocalStorage = ({FutureFn<String>? baseDirFn, List<int>? encryptionKey, bool? clear}) {
  if (!kIsWeb) {
    baseDirFn ??= () => getApplicationDocumentsDirectory().then((dir) => dir.path);
  } else {
    baseDirFn ??= () => '';
  }
  
  return hiveLocalStorageProvider
    .overrideWithProvider(Provider((ref) => HiveLocalStorage(
            hive: ref.read(hiveProvider),
            baseDirFn: baseDirFn,
            encryptionKey: encryptionKey,
            clear: clear,
          )));
};

// ignore: prefer_function_declarations_over_variables
RepositoryInitializerProvider repositoryInitializerProvider = (
        {bool? remote, bool? verbose}) {
  return _repositoryInitializerProviderFamily(
      RepositoryInitializerArgs(remote, verbose));
};

final repositoryProviders = <String, Provider<Repository<DataModel>>>{
  'ingredients': ingredientsRepositoryProvider,
'menus': menusRepositoryProvider,
'recipes': recipesRepositoryProvider,
'shoppingLists': shoppingListsRepositoryProvider,
'userPreferences': userPreferencesRepositoryProvider
};

final _repositoryInitializerProviderFamily =
  FutureProvider.family<RepositoryInitializer, RepositoryInitializerArgs>((ref, args) async {
    final adapters = <String, RemoteAdapter>{'ingredients': ref.watch(ingredientsRemoteAdapterProvider), 'menus': ref.watch(menusRemoteAdapterProvider), 'recipes': ref.watch(recipesRemoteAdapterProvider), 'shoppingLists': ref.watch(shoppingListsRemoteAdapterProvider), 'userPreferences': ref.watch(userPreferencesRemoteAdapterProvider)};
    final remotes = <String, bool>{'ingredients': true, 'menus': true, 'recipes': true, 'shoppingLists': true, 'userPreferences': true};

    await ref.watch(graphNotifierProvider).initialize();

    final _repoMap = {
      for (final type in repositoryProviders.keys)
        type: ref.watch(repositoryProviders[type]!)
    };

    for (final type in _repoMap.keys) {
      final repository = _repoMap[type]!;
      repository.dispose();
      await repository.initialize(
        remote: args.remote ?? remotes[type],
        verbose: args.verbose,
        adapters: adapters,
      );
    }

    ref.onDispose(() {
      for (final repository in _repoMap.values) {
        repository.dispose();
      }
    });

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