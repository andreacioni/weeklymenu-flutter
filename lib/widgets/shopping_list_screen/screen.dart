import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:objectid/objectid.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';

import '../../globals/constants.dart';
import '../../providers/shared_preferences.dart';
import 'shopping_list_app_bar.dart';
import '../../providers/user_preferences.dart';
import '../flutter_data_state_builder.dart';
import '../../models/ingredient.dart';
import './shopping_list_tile.dart';
import '../../globals/errors_handlers.dart';
import '../../models/shopping_list.dart';
import './item_suggestion_text_field.dart';
import 'package:weekly_menu_app/main.data.dart';

final selectedShoppingListItemsProvider =
    StateProvider.autoDispose(((_) => <String>[]));

final firstShoppingListIdProvider = FutureProvider((ref) async {
  final sharedPrefs = await ref.watch(sharedPreferenceProvider.future);
  final firstShoppingListId =
      sharedPrefs.getString(SharedPreferencesKeys.firstShoppingListId);

  if (firstShoppingListId == null) {
    final shoppingLists = await ref.shoppingLists.findAll();

    if (shoppingLists == null || shoppingLists.isEmpty) {
      return null;
    }

    sharedPrefs
        .setString(
            SharedPreferencesKeys.firstShoppingListId, shoppingLists[0].id)
        .ignore();

    //Get only the first element, by now only one list per user is supported
    return shoppingLists[0].id;
  }

  return firstShoppingListId;
});

final _availableIngredientsProvider =
    FutureProvider.autoDispose<List<Ingredient>>((ref) async {
  final ingredients =
      await ref.read(ingredientsRepositoryProvider).findAll(remote: false);

  return ingredients ?? [];
});

final _shoppingListScreeDataProvider =
    FutureProvider.autoDispose<AsyncValue<_ShoppingListScreenData>>((ref) {
  final ingredients = ref.watch(_availableIngredientsProvider);
  final shoppingListId = ref.watch(firstShoppingListIdProvider);

  if (ingredients is AsyncError || shoppingListId is AsyncError) {
    return AsyncValue.error(ingredients is AsyncError
        ? (ingredients as AsyncError).error
        : (shoppingListId as AsyncError).error);
  }

  if (ingredients is AsyncLoading || shoppingListId is AsyncLoading) {
    return const AsyncValue.loading();
  }

  if (ingredients.value == null || shoppingListId.value == null) {
    return AsyncValue.error(
        'ingredients or shoppingListId empty ($ingredients/$shoppingListId)');
  }

  return AsyncData(
      _ShoppingListScreenData(shoppingListId.value!, ingredients.value!));
});

class _ShoppingListScreenData {
  final String shoppingListId;
  final List<Ingredient> ingredients;
  const _ShoppingListScreenData(this.shoppingListId, this.ingredients);
}

class ShoppingListScreen extends HookConsumerWidget {
  ShoppingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newItemMode = useState(false);

    final asyncScreenData = ref.watch(_shoppingListScreeDataProvider);

    return Scaffold(
      appBar: const ShoppingListAppBar(),
      floatingActionButton: newItemMode.value == false
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => newItemMode.value = true,
            )
          : null,
      body: asyncScreenData.when(
        data: (data) {
          final shoppingListId = data.value!.shoppingListId;
          final availableIngredients = data.value!.ingredients;
          return _ShoppingListListView(
            shoppingListId: shoppingListId,
            availableIngredients: availableIngredients,
            newItemMode: newItemMode,
          );
        },
        error: (_, __) =>
            const Center(child: const CircularProgressIndicator()),
        loading: () => const Center(child: const CircularProgressIndicator()),
      ),
    );
  }
}

class _ShoppingListListView extends HookConsumerWidget {
  final String shoppingListId;
  final ValueNotifier<bool> newItemMode;
  final List<Ingredient> availableIngredients;

  const _ShoppingListListView(
      {Key? key,
      required this.shoppingListId,
      required this.newItemMode,
      required this.availableIngredients})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandChecked = useState(true);

    Widget _buildLoadingItem() {
      return SliverList(
        delegate: SliverChildListDelegate.fixed(
          <Widget>[
            ListTile(
              title: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Divider(height: 0)
          ],
        ),
      );
    }

    Future<void> _setItemChecked(
        ShoppingListItem shopItem, bool checked) async {
      try {
        await shopItem
            .copyWith(checked: checked)
            .save(params: {'update': true, 'shopping_list_id': shoppingListId});
      } catch (e) {
        showAlertErrorMessage(context);
        shopItem
            .copyWith(checked: !checked)
            .save(params: {'update': true, 'shopping_list_id': shoppingListId});
      }
    }

    Future<void> _createShoppingListItemByIngredient(
        Ingredient ingredient, bool checked) async {
      final shopListItems = await ref
              .read(shoppingListItemsRepositoryProvider)
              .findAll(
                  remote: false,
                  params: {'shopping_list_id': shoppingListId}) ??
          [];

      var shoppingListItem =
          shopListItems.firstWhereOrNull((i) => i.id == ingredient.id);

      if (shoppingListItem != null) {
        return _setItemChecked(shoppingListItem, checked);
      }

      shoppingListItem =
          ShoppingListItem(item: ingredient.id, checked: checked);

      try {
        await shoppingListItem.save(
            params: {'update': false, 'shopping_list_id': shoppingListId});
      } catch (e) {
        showAlertErrorMessage(context);
        shoppingListItem.deleteLocal();
      }
    }

    void _createShoppingListItemByIngredientName(
        String ingredientName, bool checked) async {
      final ingredientList = await ref
              .read(ingredientsRepositoryProvider)
              .findAll(remote: false) ??
          [];

      var ingredient = ingredientList.firstWhereOrNull((i) =>
          i.name.trim().toLowerCase() == ingredientName.trim().toLowerCase());

      if (ingredient != null) {
        return _createShoppingListItemByIngredient(ingredient, checked);
      }

      ingredient = Ingredient(id: ObjectId().hexString, name: ingredientName);

      try {
        await ingredient.save();
      } catch (e) {
        showAlertErrorMessage(context);
        ingredient.deleteLocal();
        return;
      }

      return _createShoppingListItemByIngredient(ingredient, checked);
    }

    void handleTextFieldSubmission(
        Object? value, ShoppingListItem item, bool checked) {
      if (value == null) return;
      if (value is bool) {
        _setItemChecked(item, value);
      } else if (value is ShoppingListItem) {
        _setItemChecked(item, checked);
      } else if (value is String) {
        _createShoppingListItemByIngredientName(value, checked);
      } else if (value is Ingredient) {
        _createShoppingListItemByIngredient(value, checked);
      }
    }

    Widget _buildAddItem(WidgetRef ref) {
      return SliverList(
        delegate: SliverChildListDelegate.fixed(
          <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: ItemSuggestionTextField(
                availableIngredients: availableIngredients,
                hintText: 'Add element...',
                autofocus: true,
                onFocusChanged: (hasFocus) {
                  if (hasFocus == false) {
                    newItemMode.value = false;
                  }
                },
                onSubmitted: (value) {
                  if (value is String) {
                    _createShoppingListItemByIngredientName(value, false);
                  } else if (value is ShoppingListItem) {
                    _setItemChecked(value, false);
                  } else if (value is Ingredient) {
                    _createShoppingListItemByIngredient(value, false);
                  }
                },
              ),
            ),
            Divider(
              height: 0,
            )
          ],
        ),
      );
    }

    Future<void> _removeItemFromList(ShoppingListItem shoppingListItem) async {
      try {
        await shoppingListItem.delete(
            params: {'update': true, 'shopping_list_id': shoppingListId});
      } catch (e) {
        showAlertErrorMessage(context);
        shoppingListItem.save(
            params: {'update': false, 'shopping_list_id': shoppingListId});
      }
    }

    List<Widget> _buildCheckedList(List<ShoppingListItem> checkedItems) {
      final sliverSectionMap = _sortAndFoldShoppingListItem(checkedItems);

      final tilesAndSectionTitle = sliverSectionMap.entries
          .map((e) {
            final sectionColor = ref
                .read(supermarketSectionByNameProvider(
                    e.value[0].supermarketSectionName))
                ?.color;

            return <Widget>[
              _SupermarketSectionTitle(
                sectionColor: sectionColor,
                sectionName: e.key,
                textColor: Colors.grey,
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  e.value
                      .map(
                        (item) => ShoppingListItemTile(
                          item,
                          availableIngredients: availableIngredients,
                          formKey: ValueKey(item.item),
                          editable: true,
                          onSubmitted: (value) {
                            handleTextFieldSubmission(value, item, false);
                          },
                          onDismiss: (_) => _removeItemFromList(item),
                        ),
                      )
                      .toList(),
                ),
              ),
            ];
          })
          .expand((e) => e) //flat
          .toList();

      return [
        SliverAppBar(
          primary: false,
          pinned: true,
          title: Text("Checked (${checkedItems.length})"),
          forceElevated: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey.shade100,
          centerTitle: false,
          actions: <Widget>[
            if (expandChecked.value)
              IconButton(
                icon: Icon(Icons.expand_less),
                onPressed: () => expandChecked.value = false,
              ),
            if (!expandChecked.value)
              IconButton(
                icon: Icon(Icons.expand_more),
                onPressed: () => expandChecked.value = true,
              )
          ],
        ),
        if (expandChecked.value) ...tilesAndSectionTitle
      ];
    }

    List<Widget> _buildUncheckedList(List<ShoppingListItem> uncheckedItems) {
      final sliverSectionMap = _sortAndFoldShoppingListItem(uncheckedItems);

      return sliverSectionMap.entries
          .map((e) {
            final sectionColor = ref
                .read(supermarketSectionByNameProvider(
                    e.value[0].supermarketSectionName))
                ?.color;

            return <Widget>[
              _SupermarketSectionTitle(
                sectionColor: sectionColor,
                sectionName: e.key,
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  e.value
                      .map(
                        (item) => ShoppingListItemTile(
                          item,
                          availableIngredients: availableIngredients,
                          formKey: ValueKey(item.item),
                          editable: true,
                          onSubmitted: (value) {
                            handleTextFieldSubmission(value, item, true);
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ];
          })
          .expand((e) => e) //flat
          .toList();
    }

    Widget _buildNoElementsPage() {
      final _textColor = Colors.grey.shade300;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_box,
              size: 150,
              color: _textColor,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Your Shopping List Is Empty',
              style: TextStyle(
                fontSize: 25,
                color: _textColor,
              ),
            ),
          ],
        ),
      );
    }

    return FlutterDataStateBuilder<List<ShoppingListItem>>(
      state: ref.shoppingListItems
          .watchAll(params: {'shopping_list_id': shoppingListId}),
      loading: _buildLoadingItem(),
      notFound: _buildNoElementsPage(),
      onRefresh: () => ref.shoppingListItems.findAll(
          params: {'shopping_list_id': shoppingListId}, syncLocal: true),
      builder: (context, data) {
        final allItems = data;
        final checkedItems = allItems.where((i) => i.checked).toList();
        final uncheckedItems = allItems.where((i) => !i.checked).toList();

        return CustomScrollView(
          slivers: <Widget>[
            if (newItemMode.value) _buildAddItem(ref),
            if (allItems.isNotEmpty) ..._buildUncheckedList(uncheckedItems),
            if (allItems.isNotEmpty) ..._buildCheckedList(checkedItems),
          ],
        );
      },
    );
  }

  static Map<String, List<ShoppingListItem>> _sortAndFoldShoppingListItem(
      List<ShoppingListItem> items) {
    final ordered = [...items]..sort((a, b) => (b.supermarketSectionName ?? '')
        .compareTo(a.supermarketSectionName ?? ''));

    return ordered.fold<Map<String, List<ShoppingListItem>>>(
        <String, List<ShoppingListItem>>{}, (pv, e) {
      final currentList = pv[e.supermarketSectionName ?? ''];
      if (currentList == null) {
        pv[e.supermarketSectionName ?? ''] = [e];
      } else {
        pv[e.supermarketSectionName ?? '']!.add(e);
      }
      return pv;
    });
  }
}

class _SupermarketSectionTitle extends StatelessWidget {
  static const SUPERMARKET_SECTION_TITLE_HEIGHT = 30.0;

  final String sectionName;
  final Color? sectionColor;
  final Color? textColor;

  const _SupermarketSectionTitle(
      {Key? key,
      this.sectionColor,
      this.textColor = Colors.black,
      this.sectionName = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Container(
        height: SUPERMARKET_SECTION_TITLE_HEIGHT,
        color: sectionColor?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
        child: Row(
          children: [
            Container(
              color: sectionColor,
              width: 6,
              height: SUPERMARKET_SECTION_TITLE_HEIGHT,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(sectionName,
                  style: textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
