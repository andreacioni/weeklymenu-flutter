import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weekly_menu_app/widgets/shopping_list_screen/screen.dart';

import '../flutter_data_state_builder.dart';
import '../../models/shopping_list.dart';
import '../../models/ingredient.dart';
import './item_suggestion_text_field.dart';
import 'package:weekly_menu_app/main.data.dart';

class ShoppingListItemTile extends HookConsumerWidget {
  final Key formKey;
  final ShoppingListItem shoppingListItem;
  final Function(bool)? onCheckChange;
  final Function(DismissDirection)? onDismiss;
  final bool editable;

  ShoppingListItemTile(
    this.shoppingListItem, {
    required this.formKey,
    this.onCheckChange,
    this.onDismiss,
    this.editable = true,
  }) : super(key: formKey);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientsRepository = ref.ingredients;
    final editingMode = useState(false);
    final shopItem = useState(shoppingListItem);
    final selectedItems = ref.watch(selectedShoppingListItems);

    void _onFocusChanged(bool hasFocus) {
      if (hasFocus == false) {
        editingMode.value = false;
      } else {
        editingMode.value = true;
      }
    }

    void _onIngredientSelected(Ingredient newIngredient) {
      editingMode.value = false;
    }

    void _getOrCreateIngredientByName(ingredientName) {
      editingMode.value = false;
    }

    void _onCheckChange(newValue) {
      shopItem.value = shopItem.value.copyWith(checked: newValue);

      if (onCheckChange != null) {
        onCheckChange!(newValue);
      }
    }

    void toggleItemToSelectedItems(String itemId) {
      if (!selectedItems.contains(itemId)) {
        ref
            .read(selectedShoppingListItems.notifier)
            .update((state) => [...state, itemId]);
      } else {
        ref
            .read(selectedShoppingListItems.notifier)
            .update((state) => [...state..removeWhere((e) => e == itemId)]);
      }
    }

    return FlutterDataStateBuilder<Ingredient>(
      state: ingredientsRepository.watchOne(shoppingListItem.item),
      onRefresh: () => ingredientsRepository.findOne(shoppingListItem.item),
      builder: (context, model) {
        return Dismissible(
          direction: selectedItems.isNotEmpty
              ? DismissDirection.none
              : DismissDirection.endToStart,
          key: formKey,
          onDismissed: onDismiss,
          child: Column(
            children: <Widget>[
              InkWell(
                onLongPress: () =>
                    toggleItemToSelectedItems(shoppingListItem.item),
                onTap: selectedItems.isNotEmpty
                    ? () => toggleItemToSelectedItems(shoppingListItem.item)
                    : null,
                child: ListTile(
                  selected: selectedItems.contains(shoppingListItem.item),
                  contentPadding: EdgeInsets.only(right: 16),
                  leading: Container(color: Colors.red, width: 6),
                  trailing: selectedItems.isEmpty
                      ? Checkbox(
                          value: shoppingListItem.checked,
                          onChanged: _onCheckChange,
                        )
                      : null,
                  title: ItemSuggestionTextField(
                    value: model,
                    enabled: editable,
                    showShoppingItemSuggestions: false,
                    onIngredientSelected: _onIngredientSelected,
                    onSubmitted: _getOrCreateIngredientByName,
                    onFocusChanged: _onFocusChanged,
                    textStyle: shoppingListItem.checked
                        ? TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              Divider(height: 0)
            ],
          ),
        );
      },
    );
  }
}
