

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: directives_ordering, top_level_function_literal_block

import 'package:flutter_data/flutter_data.dart';
import 'package:path_provider/path_provider.dart';

import 'package:weekly_menu_app/models/ingredient.dart';
import 'package:weekly_menu_app/models/menu.dart';
import 'package:weekly_menu_app/models/recipe.dart';
import 'package:weekly_menu_app/models/shopping_list.dart';

// ignore: prefer_function_declarations_over_variables
ConfigureRepositoryLocalStorage configureRepositoryLocalStorage = ({FutureFn<String> baseDirFn, List<int> encryptionKey, bool clear}) {
  // ignore: unnecessary_statements
  baseDirFn ??= () => getApplicationDocumentsDirectory().then((dir) => dir.path);
  return hiveLocalStorageProvider.overrideWithProvider(Provider(
        (_) => HiveLocalStorage(baseDirFn: baseDirFn, encryptionKey: encryptionKey, clear: clear)));
};

// ignore: prefer_function_declarations_over_variables
RepositoryInitializerProvider repositoryInitializerProvider = (
        {bool remote, bool verbose}) {
  return _repositoryInitializerProviderFamily(
      RepositoryInitializerArgs(remote, verbose));
};

final repositoryProviders = {
  'ingredients': ingredientsRepositoryProvider,
'menus': menusRepositoryProvider,
'recipes': recipesRepositoryProvider,
'shoppingLists': shoppingListsRepositoryProvider
};

final _repositoryInitializerProviderFamily =
  FutureProvider.family<RepositoryInitializer, RepositoryInitializerArgs>((ref, args) async {
    final adapters = <String, RemoteAdapter>{'ingredients': ref.read(ingredientsRemoteAdapterProvider), 'menus': ref.read(menusRemoteAdapterProvider), 'recipes': ref.read(recipesRemoteAdapterProvider), 'shoppingLists': ref.read(shoppingListsRemoteAdapterProvider)};
    final remotes = <String, bool>{'ingredients': true, 'menus': true, 'recipes': true, 'shoppingLists': true};

    for (final key in repositoryProviders.keys) {
      final repository = ref.read(repositoryProviders[key]);
      repository.dispose();
      await repository.initialize(
        remote: args?.remote ?? remotes[key],
        verbose: args?.verbose,
        adapters: adapters,
      );
    }

    ref.onDispose(() {
      if (ref.mounted) {
        for (final repositoryProvider in repositoryProviders.values) {
          ref.read(repositoryProvider).dispose();
        }
      }
    });

    return RepositoryInitializer();
});
