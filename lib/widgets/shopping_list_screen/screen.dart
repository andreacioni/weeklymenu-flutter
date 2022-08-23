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
import '../../main.data.dart';

final selectedShoppingListItemsProvider =
    StateProvider.autoDispose(((_) => <String>[]));

final firstShoppingListIdProvider = FutureProvider<String>((ref) async {
  final sharedPrefs = await ref.watch(sharedPreferenceProvider.future);
  final firstShoppingListId =
      sharedPrefs.getString(SharedPreferencesKeys.firstShoppingListId);

  if (firstShoppingListId == null) {
    final shoppingLists = await ref.shoppingLists.findAll();

    if (shoppingLists == null || shoppingLists.isEmpty) {
      throw 'unexpected condition: shopping list is null or empty';
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

    final firstShoppingListAsyncData = ref.watch(firstShoppingListIdProvider);

    return Scaffold(
      appBar: const ShoppingListAppBar(),
      floatingActionButton: newItemMode.value == false
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => newItemMode.value = true,
            )
          : null,
      body: firstShoppingListAsyncData.when(
        data: (shoppingListId) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: _ShoppingListListView(
              shoppingListId: shoppingListId,
              newItemMode: newItemMode,
            ),
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

    Future<void> _setItemChecked(
        ShoppingListItem shopItem, bool checked) async {
      try {
        await shopItem.copyWith(checked: checked).save(params: {
          UPDATE_PARAM: true,
          SHOPPING_LIST_ID_PARAM: shoppingListId
        });
      } catch (e) {
        showAlertErrorMessage(context);
        shopItem.copyWith(checked: !checked).save(params: {
          UPDATE_PARAM: true,
          SHOPPING_LIST_ID_PARAM: shoppingListId
        });
      }
    }

    Future<void> _createShoppingListItemByIngredient(
        Ingredient ingredient, bool checked,
        [ShoppingListItem? previousItem]) async {
      if (previousItem != null && previousItem.item != ingredient.id) {
        //selected item mismatch, delete the previous item before going further
        previousItem.delete(params: {
          SHOPPING_LIST_ID_PARAM: shoppingListId,
          UPDATE_PARAM: true
        });
      }

      final shopListItems = await ref
              .read(shoppingListItemsRepositoryProvider)
              .findAll(
                  remote: false,
                  params: {SHOPPING_LIST_ID_PARAM: shoppingListId}) ??
          [];

      var shoppingListItem =
          shopListItems.firstWhereOrNull((i) => i.id == ingredient.id);

      if (shoppingListItem != null) {
        return _setItemChecked(shoppingListItem, checked);
      }

      shoppingListItem =
          ShoppingListItem(item: ingredient.id, checked: checked);

      try {
        await shoppingListItem.save(params: {
          UPDATE_PARAM: false,
          SHOPPING_LIST_ID_PARAM: shoppingListId
        });
      } catch (e) {
        showAlertErrorMessage(context);
        shoppingListItem.deleteLocal();
      }
    }

    void _createShoppingListItemByIngredientName(
        String ingredientName, bool checked,
        [ShoppingListItem? previousItem]) async {
      if (previousItem != null) {
        final previousIngredient = await ref
            .read(ingredientsRepositoryProvider)
            .findOne(previousItem.id);

        if (previousIngredient?.name.trim() != ingredientName.trim()) {
          //selected item mismatch, delete the previous item before going further
          previousItem.delete(params: {
            SHOPPING_LIST_ID_PARAM: shoppingListId,
            UPDATE_PARAM: true
          });
        }
      }

      final ingredientList = await ref
              .read(ingredientsRepositoryProvider)
              .findAll(remote: false) ??
          [];

      var ingredient = ingredientList
          .firstWhereOrNull((i) => i.name.trim() == ingredientName.trim());

      if (ingredient != null) {
        return _createShoppingListItemByIngredient(ingredient, checked);
      }

      ingredient =
          Ingredient(id: ObjectId().hexString, name: ingredientName.trim());

      try {
        await ingredient.save();
      } catch (e) {
        showAlertErrorMessage(context);
        ingredient.deleteLocal();
        return;
      }

      return _createShoppingListItemByIngredient(ingredient, checked);
    }

    Future<void> handleTextFieldSubmission(
        Object? newValue, ShoppingListItem? previousItem, bool checked) async {
      if (newValue == null) return;

      if (previousItem != null) {
        //UPDATE ITEM
        if (newValue is bool) {
          _setItemChecked(previousItem, newValue);
        } else if (newValue is ShoppingListItem) {
          if (newValue.item != previousItem.item) {
            //selected item mismatch, delete the previous item before going further
            previousItem.delete(params: {
              SHOPPING_LIST_ID_PARAM: shoppingListId,
              UPDATE_PARAM: true
            });
            _setItemChecked(newValue, checked);
          } else {
            //item is the same, we must check the checked value to understand if we have to toggle the value
            if (newValue.checked != checked) {
              _setItemChecked(newValue, checked);
            }
          }
        } else if (newValue is String) {
          _createShoppingListItemByIngredientName(
              newValue, checked, previousItem);
        } else if (newValue is Ingredient) {
          _createShoppingListItemByIngredient(newValue, checked, previousItem);
        }
      } else {
        //CREATE ITEM
        if (newValue is String) {
          _createShoppingListItemByIngredientName(newValue, checked);
        } else if (newValue is ShoppingListItem) {
          _setItemChecked(newValue, checked);
        } else if (newValue is Ingredient) {
          _createShoppingListItemByIngredient(newValue, checked);
        }
      }
    }

    Widget _buildAddItem() {
      return SliverList(
        delegate: SliverChildListDelegate.fixed(
          <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: ItemSuggestionTextField(
                hintText: 'Add element...',
                autofocus: true,
                onFocusChanged: (hasFocus) {
                  if (hasFocus == false) {
                    newItemMode.value = false;
                  }
                },
                onSubmitted: (value) {
                  handleTextFieldSubmission(value, null, false);
                  newItemMode.value = false;
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
        await shoppingListItem.delete(params: {
          UPDATE_PARAM: true,
          SHOPPING_LIST_ID_PARAM: shoppingListId
        });
      } catch (e) {
        showAlertErrorMessage(context);
        shoppingListItem.save(params: {
          UPDATE_PARAM: false,
          SHOPPING_LIST_ID_PARAM: shoppingListId
        });
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
                          formKey: ValueKey(item.item),
                          editable: true,
                          onSubmitted: (value) {
                            handleTextFieldSubmission(value, item, true);
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
    }

    Widget _buildAddFirstItemFieldWrapper() {
      return CustomScrollView(
        slivers: [_buildAddItem()],
      );
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
          .watchAll(params: {SHOPPING_LIST_ID_PARAM: shoppingListId}),
      loading: _buildLoadingItem(),
      notFound: newItemMode.value
          ? _buildAddFirstItemFieldWrapper()
          : _buildNoElementsPage(),
      onRefresh: () => ref.shoppingListItems.findAll(
          params: {SHOPPING_LIST_ID_PARAM: shoppingListId}, syncLocal: true),
      builder: (context, data) {
        final allItems = data;
        final checkedItems = allItems.where((i) => i.checked).toList();
        final uncheckedItems = allItems.where((i) => !i.checked).toList();

        return CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: <Widget>[
            if (newItemMode.value) _buildAddItem(),
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
