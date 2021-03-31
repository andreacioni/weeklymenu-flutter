

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: directives_ordering, top_level_function_literal_block

import 'package:flutter_data/flutter_data.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart' as p hide ReadContext;
import 'package:provider/single_child_widget.dart';



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

final _repositoryInitializerProviderFamily =
  FutureProvider.family<RepositoryInitializer, RepositoryInitializerArgs>((ref, args) async {
    final graphs = <String, Map<String, RemoteAdapter>>{'ingredients': {'ingredients': ref.read(ingredientRemoteAdapterProvider)}, 'menus': {'menus': ref.read(menuRemoteAdapterProvider)}, 'recipes': {'recipes': ref.read(recipeRemoteAdapterProvider)}, 'shoppingLists': {'shoppingLists': ref.read(shoppingListRemoteAdapterProvider)}};
    

      final _ingredientRepository = ref.read(ingredientRepositoryProvider);
      _ingredientRepository.dispose();
      await _ingredientRepository.initialize(
        remote: args?.remote,
        verbose: args?.verbose,
        adapters: graphs['ingredients'],
      );

      final _menuRepository = ref.read(menuRepositoryProvider);
      _menuRepository.dispose();
      await _menuRepository.initialize(
        remote: args?.remote,
        verbose: args?.verbose,
        adapters: graphs['menus'],
      );

      final _recipeRepository = ref.read(recipeRepositoryProvider);
      _recipeRepository.dispose();
      await _recipeRepository.initialize(
        remote: args?.remote,
        verbose: args?.verbose,
        adapters: graphs['recipes'],
      );

      final _shoppingListRepository = ref.read(shoppingListRepositoryProvider);
      _shoppingListRepository.dispose();
      await _shoppingListRepository.initialize(
        remote: args?.remote,
        verbose: args?.verbose,
        adapters: graphs['shoppingLists'],
      );

    ref.onDispose(() {
      if (ref.mounted) {
              ref.read(ingredientRepositoryProvider).dispose();
      ref.read(menuRepositoryProvider).dispose();
      ref.read(recipeRepositoryProvider).dispose();
      ref.read(shoppingListRepositoryProvider).dispose();

      }
    });

    return RepositoryInitializer();
});



List<SingleChildWidget> repositoryProviders({FutureFn<String> baseDirFn, List<int> encryptionKey,
    bool clear, bool remote, bool verbose}) {

  return [
    p.Provider(
        create: (_) => ProviderContainer(
          overrides: [
            configureRepositoryLocalStorage(
                baseDirFn: baseDirFn, encryptionKey: encryptionKey, clear: clear),
          ]
      ),
    ),
    p.FutureProvider<RepositoryInitializer>(
      create: (context) async {
        final init = await p.Provider.of<ProviderContainer>(context, listen: false).read(repositoryInitializerProvider(remote: remote, verbose: verbose).future);
        internalLocatorFn = (provider, context) => p.Provider.of<ProviderContainer>(context, listen: false).read(provider);
        return init;
      },
    ),    p.ProxyProvider<RepositoryInitializer, Repository<Ingredient>>(
      lazy: false,
      update: (context, i, __) => i == null ? null : p.Provider.of<ProviderContainer>(context, listen: false).read(ingredientRepositoryProvider),
      dispose: (_, r) => r?.dispose(),
    ),
    p.ProxyProvider<RepositoryInitializer, Repository<Menu>>(
      lazy: false,
      update: (context, i, __) => i == null ? null : p.Provider.of<ProviderContainer>(context, listen: false).read(menuRepositoryProvider),
      dispose: (_, r) => r?.dispose(),
    ),
    p.ProxyProvider<RepositoryInitializer, Repository<Recipe>>(
      lazy: false,
      update: (context, i, __) => i == null ? null : p.Provider.of<ProviderContainer>(context, listen: false).read(recipeRepositoryProvider),
      dispose: (_, r) => r?.dispose(),
    ),
    p.ProxyProvider<RepositoryInitializer, Repository<ShoppingList>>(
      lazy: false,
      update: (context, i, __) => i == null ? null : p.Provider.of<ProviderContainer>(context, listen: false).read(shoppingListRepositoryProvider),
      dispose: (_, r) => r?.dispose(),
    ),]; }


