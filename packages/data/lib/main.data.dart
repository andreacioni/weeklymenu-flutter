

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: directives_ordering, top_level_function_literal_block, depend_on_referenced_packages

import 'package:flutter_data/flutter_data.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:data/flutter_data/ingredient.dart';
import 'package:data/flutter_data/menu.dart';
import 'package:data/flutter_data/recipe.dart';
import 'package:data/flutter_data/shopping_list.dart';
import 'package:data/flutter_data/user_preferences.dart';

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

final repositoryProviders = <String, Provider<Repository<DataModelMixin>>>{
  'ingredients': flutterDataIngredientsRepositoryProvider,
'menus': flutterDataMenusRepositoryProvider,
'recipes': flutterDataRecipesRepositoryProvider,
'shopping-lists': flutterDataShoppingListsRepositoryProvider,
'userPreferences': flutterDataUserPreferencesRepositoryProvider
};

final repositoryInitializerProvider =
  FutureProvider<RepositoryInitializer>((ref) async {
    DataHelpers.setInternalType<FlutterDataIngredient>('ingredients');
    DataHelpers.setInternalType<FlutterDataMenu>('menus');
    DataHelpers.setInternalType<FlutterDataRecipe>('recipes');
    DataHelpers.setInternalType<FlutterDataShoppingList>('shopping-lists');
    DataHelpers.setInternalType<FlutterDataUserPreference>('userPreferences');
    final adapters = <String, RemoteAdapter>{'ingredients': ref.watch(internalFlutterDataIngredientsRemoteAdapterProvider), 'menus': ref.watch(internalFlutterDataMenusRemoteAdapterProvider), 'recipes': ref.watch(internalFlutterDataRecipesRemoteAdapterProvider), 'shopping-lists': ref.watch(internalFlutterDataShoppingListsRemoteAdapterProvider), 'userPreferences': ref.watch(internalFlutterDataUserPreferencesRemoteAdapterProvider)};
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
  Repository<FlutterDataIngredient> get flutterDataIngredients => watch(flutterDataIngredientsRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<FlutterDataMenu> get flutterDataMenus => watch(flutterDataMenusRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<FlutterDataRecipe> get flutterDataRecipes => watch(flutterDataRecipesRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<FlutterDataShoppingList> get flutterDataShoppingLists => watch(flutterDataShoppingListsRepositoryProvider)..remoteAdapter.internalWatch = watch;
  Repository<FlutterDataUserPreference> get flutterDataUserPreferences => watch(flutterDataUserPreferencesRepositoryProvider)..remoteAdapter.internalWatch = watch;
}

extension RepositoryRefX on Ref {

  Repository<FlutterDataIngredient> get flutterDataIngredients => watch(flutterDataIngredientsRepositoryProvider)..remoteAdapter.internalWatch = watch as Watcher;
  Repository<FlutterDataMenu> get flutterDataMenus => watch(flutterDataMenusRepositoryProvider)..remoteAdapter.internalWatch = watch as Watcher;
  Repository<FlutterDataRecipe> get flutterDataRecipes => watch(flutterDataRecipesRepositoryProvider)..remoteAdapter.internalWatch = watch as Watcher;
  Repository<FlutterDataShoppingList> get flutterDataShoppingLists => watch(flutterDataShoppingListsRepositoryProvider)..remoteAdapter.internalWatch = watch as Watcher;
  Repository<FlutterDataUserPreference> get flutterDataUserPreferences => watch(flutterDataUserPreferencesRepositoryProvider)..remoteAdapter.internalWatch = watch as Watcher;
}