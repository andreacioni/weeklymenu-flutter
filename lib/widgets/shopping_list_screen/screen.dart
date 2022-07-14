import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:objectid/objectid.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weekly_menu_app/globals/constants.dart';
import 'package:weekly_menu_app/providers/shared_preferences.dart';
import 'package:weekly_menu_app/widgets/shopping_list_screen/shopping_list_app_bar.dart';

import '../flutter_data_state_builder.dart';
import '../../models/ingredient.dart';
import './shopping_list_tile.dart';
import '../../globals/errors_handlers.dart';
import '../../models/shopping_list.dart';
import './item_suggestion_text_field.dart';
import 'package:weekly_menu_app/main.data.dart';

final selectedShoppingListItems =
    StateProvider.autoDispose(((_) => <String>[]));

final supermarketSectionList = Provider.autoDispose(((ref) {
  final shoppingListItems = ref.shoppingLists.watchAll().model![0].items;
  return (shoppingListItems
        ..removeWhere((e) => e.supermarketSectionName?.isEmpty ?? false))
      .map((e) => e.supermarketSectionName)
      .toSet()
      .toList();
}));

final firstShoppingListIdProvider = FutureProvider((ref) async {
  final firstShoppingListId = (await ref.watch(sharedPreferenceProvider.future))
      .getString(SharedPreferencesKeys.firstShoppingListId);
  if (firstShoppingListId == null) {
    final shoppingLists = await ref.shoppingLists.findAll();

    if (shoppingLists == null || shoppingLists.isEmpty) {
      return null;
    }

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
    final expandChecked = useState(true);

    final loadingShoppingListId = ref.watch(firstShoppingListIdProvider);

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
        WidgetRef ref, ShoppingList shoppingList, Ingredient ing) async {
      ShoppingListItem item = ShoppingListItem(item: ing.id, checked: false);

      shoppingList.addShoppingListItem(item);

      try {
        await ref.shoppingLists.save(shoppingList, params: {'update': true});
      } catch (e) {
        showAlertErrorMessage(context);
        shoppingList.removeItemFromList(item);
      }
    }

    void _createNewIngredientAndShopItem(
        WidgetRef ref, ShoppingList shoppingList, String ingredientName) async {
      Repository<Ingredient> ingredientsRepo =
          ref.read(ingredientsRepositoryProvider);

      Ingredient newIngredient =
          Ingredient(id: ObjectId().hexString, name: ingredientName);
      ingredientsRepo.save(newIngredient, params: {'update': false});

      _createShopItemForIngredient(ref, shoppingList, newIngredient);
    }

    Future<void> _setChecked(WidgetRef ref, ShoppingList shoppingList,
        ShoppingListItem shopItem, bool checked) async {
      try {
        await shoppingList
            .setChecked(shopItem, checked)
            .save(params: {'update': true});
      } catch (e) {
        showAlertErrorMessage(context);
        shoppingList.setChecked(
          shopItem,
          !checked,
        );
      }
    }

    Widget _buildAddItem(WidgetRef ref, String shoppingListId) {
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
                  ref,
                  shoppingListId,
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

    Future<void> _removeItemFromList(WidgetRef ref, ShoppingList shoppingList,
        ShoppingListItem shoppingListItem) async {
      shoppingList.removeItemFromList(shoppingListItem);
      try {
        await ref
            .read(shoppingListsRepositoryProvider)
            .save(shoppingList, params: {'update': true});
      } catch (e) {
        showAlertErrorMessage(context);
        shoppingList.addShoppingListItem(shoppingListItem);
      }
    }

    List<Widget> _buildCheckedList(WidgetRef ref, String shoppingList) {
      final checkItems = shoppingList.getCheckedItems
        ..sort((a, b) => (a.supermarketSectionName ?? '')
            .compareTo(b.supermarketSectionName ?? ''));

      return [
        SliverAppBar(
          primary: false,
          pinned: true,
          title: Text("Checked (${checkItems.length})"),
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
        if (expandChecked.value)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => ShoppingListItemTile(checkItems[index],
                  editable: false,
                  formKey: ValueKey(checkItems[index].item),
                  onCheckChange: (newValue) => _setChecked(
                        ref,
                        shoppingList,
                        checkItems[index],
                        newValue,
                      ),
                  onDismiss: (_) => _removeItemFromList(
                      ref, shoppingList, checkItems[index])),
              childCount: checkItems.length,
            ),
          )
      ];
    }

    List<Widget> _buildUncheckedList(WidgetRef ref, String shoppingListId) {
      final uncheckItems = shoppingList.getUncheckedItems
        ..sort((a, b) => (a.supermarketSectionName ?? '')
            .compareTo(b.supermarketSectionName ?? ''));
      return [
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (_, index) => ShoppingListItemTile(
                    uncheckItems[index],
                    formKey: ValueKey(uncheckItems[index].item),
                    editable: false,
                    onCheckChange: (newValue) => _setChecked(
                      ref,
                      shoppingList,
                      uncheckItems[index],
                      newValue,
                    ),
                    onDismiss: (_) => _removeItemFromList(
                      ref,
                      shoppingList,
                      uncheckItems[index],
                    ),
                  ),
              childCount: uncheckItems.length),
        ),
      ];
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

    Widget buildItemList(String shoppingListId) {
      return FlutterDataStateBuilder<List<ShoppingListItem>>(
        state: ref.shoppingListItems.watchAll(syncLocal: true),
        loading: _buildLoadingItem(),
        onRefresh: () => ref.shoppingLists.findAll(syncLocal: true),
        //notFound: _buildNoElementsPage(),
        builder: (context, data) {
          if (data.isEmpty) {
            return _buildNoElementsPage();
          }
          final allItems = data;

          return allItems.isEmpty && !newItemMode.value
              ? _buildNoElementsPage()
              : CustomScrollView(
                  slivers: <Widget>[
                    //if (allItems.isEmpty) _buildNoElementsPage(),
                    if (newItemMode.value) _buildAddItem(ref, shoppingListId),
                    //_buildFloatingHeader('Unckecked'),
                    if (allItems.isNotEmpty)
                      ..._buildUncheckedList(ref, shoppingListId),
                    //_buildFloatingHeader('Checked'),
                    if (allItems.isNotEmpty)
                      ..._buildCheckedList(ref, shoppingListId),
                  ],
                );
        },
      );
    }

    return Scaffold(
      appBar: const ShoppingListAppBar(),
      floatingActionButton: newItemMode.value == false
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => newItemMode.value = true,
            )
          : null,
      body: loadingShoppingListId.when(
        data: (shoppingListId) {
          if (shoppingListId == null) {
            print('no shopping list available');
            return _buildNoElementsPage();
          }
          return buildItemList(shoppingListId);
        },
        error: (error, __) {
          print('failed to read shopping list id: $error');
          _buildNoElementsPage();
        },
        loading: _buildLoadingItem,
      ),
    );
  }
}
