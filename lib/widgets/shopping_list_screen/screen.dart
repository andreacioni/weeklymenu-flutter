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

final _supermarketSectionList = Provider.autoDispose(((ref) {
  final shoppingListItems = ref.shoppingLists.watchAll().model![0].items;
  return (shoppingListItems
        ..removeWhere((e) => e.supermarketSectionName?.isEmpty ?? false))
      .map((e) => e.supermarketSectionName)
      .toSet()
      .toList();
}));

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
      final checkItems = checkedItems
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
                        checkItems[index],
                        newValue,
                      ),
                  onDismiss: (_) => _removeItemFromList(checkItems[index])),
              childCount: checkItems.length,
            ),
          )
      ];
    }

    List<Widget> _buildUncheckedList(List<ShoppingListItem> uncheckedItems) {
      final uncheckItems = uncheckedItems
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
                      uncheckItems[index],
                      newValue,
                    ),
                    onDismiss: (_) => _removeItemFromList(
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
}
