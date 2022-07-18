import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:objectid/objectid.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weekly_menu_app/globals/constants.dart';
import 'package:weekly_menu_app/providers/shared_preferences.dart';
import 'package:weekly_menu_app/widgets/shopping_list_screen/shopping_list_app_bar.dart';

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

final _firstShoppingListIdProvider = FutureProvider((ref) async {
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

class ShoppingListScreen extends HookConsumerWidget {
  ShoppingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newItemMode = useState(false);

    final shoppingListId = ref.watch(_firstShoppingListIdProvider);

    return Scaffold(
      appBar: const ShoppingListAppBar(),
      floatingActionButton: newItemMode.value == false
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => newItemMode.value = true,
            )
          : null,
      body: shoppingListId.when(
          data: (data) {
            return _ShoppingListListView(
              shoppingListId: data!,
              newItemMode: newItemMode,
            );
          },
          error: (_, __) =>
              const Center(child: const CircularProgressIndicator()),
          loading: () =>
              const Center(child: const CircularProgressIndicator())),
    );
  }
}

class _ShoppingListListView extends HookConsumerWidget {
  final String shoppingListId;
  final ValueNotifier<bool> newItemMode;

  const _ShoppingListListView(
      {Key? key, required this.shoppingListId, required this.newItemMode})
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

    Future<void> _createShopItemForIngredient(
        WidgetRef ref, String shoppingList, Ingredient ing) async {
      ShoppingListItem item = ShoppingListItem(item: ing.id, checked: false);

      try {
        await ref.shoppingListItems.save(item,
            params: {'update': false, 'shopping_list_id': shoppingListId});
      } catch (e) {
        showAlertErrorMessage(context);
        ref.shoppingListItems.delete(item);
      }
    }

    void _createNewIngredientAndShopItem(
        WidgetRef ref, String shoppingList, String ingredientName) async {
      Repository<Ingredient> ingredientsRepo =
          ref.read(ingredientsRepositoryProvider);

      Ingredient newIngredient =
          Ingredient(id: ObjectId().hexString, name: ingredientName);
      ingredientsRepo.save(newIngredient,
          params: {'update': false, 'shopping_list_id': shoppingListId});

      _createShopItemForIngredient(ref, shoppingList, newIngredient);
    }

    Future<void> _setChecked(ShoppingListItem shopItem, bool checked) async {
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

    Widget _buildAddItem(WidgetRef ref) {
      return SliverList(
        delegate: SliverChildListDelegate.fixed(
          <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: ItemSuggestionTextField(
                hintText: 'Add element...',
                autoFocus: true,
                onFocusChanged: (hasFocus) {
                  if (hasFocus == false) {
                    newItemMode.value = false;
                  }
                },
                onSubmitted: (ingredientName) =>
                    _createNewIngredientAndShopItem(
                        ref, shoppingListId, ingredientName),
                onShoppingItemSelected: (shopItem) => _setChecked(
                  shopItem,
                  false,
                ),
                onIngredientSelected: (ingredient) =>
                    _createShopItemForIngredient(
                        ref, shoppingListId, ingredient),
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

      final textTheme = Theme.of(context).textTheme;

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
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  e.value
                      .map(
                        (item) => ShoppingListItemTile(
                          item,
                          formKey: ValueKey(item.item),
                          editable: false,
                          onCheckChange: (newValue) => _setChecked(
                            item,
                            newValue,
                          ),
                          onDismiss: (_) => _removeItemFromList(
                            item,
                          ),
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

      final textTheme = Theme.of(context).textTheme;

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
                          formKey: ValueKey(item.item),
                          editable: false,
                          onCheckChange: (newValue) => _setChecked(
                            item,
                            newValue,
                          ),
                          onDismiss: (_) => _removeItemFromList(
                            item,
                          ),
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
            //if (allItems.isEmpty) _buildNoElementsPage(),
            if (newItemMode.value) _buildAddItem(ref),
            //_buildFloatingHeader('Unckecked'),
            if (allItems.isNotEmpty) ..._buildUncheckedList(uncheckedItems),
            //_buildFloatingHeader('Checked'),
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

  const _SupermarketSectionTitle(
      {Key? key, this.sectionColor, this.sectionName = ''})
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
                  style: textTheme.subtitle2!
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
