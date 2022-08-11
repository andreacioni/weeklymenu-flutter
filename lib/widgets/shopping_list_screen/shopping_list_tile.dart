import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/providers/user_preferences.dart';
import 'package:weekly_menu_app/widgets/shopping_list_screen/screen.dart';

import '../flutter_data_state_builder.dart';
import '../../models/shopping_list.dart';
import '../../models/ingredient.dart';
import './item_suggestion_text_field.dart';
import 'package:weekly_menu_app/main.data.dart';

class ShoppingListItemTile extends HookConsumerWidget {
  final Key formKey;
  final ShoppingListItem shoppingListItem;
  final bool editable;
  final void Function(Object? value)? onSubmitted;
  final void Function(DismissDirection)? onDismiss;
  final List<Ingredient> availableIngredients;

  ShoppingListItemTile(
    this.shoppingListItem, {
    required this.formKey,
    required this.availableIngredients,
    this.editable = true,
    this.onSubmitted,
    this.onDismiss,
  }) : super(key: formKey);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientsRepository = ref.ingredients;
    final selectedItems = ref.read(selectedShoppingListItemsProvider);
    final supermarketSection = ref.read(supermarketSectionByNameProvider(
        shoppingListItem.supermarketSectionName));

    void toggleItemToSelectedItems(String itemId) {
      if (!selectedItems.contains(itemId)) {
        ref
            .read(selectedShoppingListItemsProvider.notifier)
            .update((state) => [...state, itemId]);
      } else {
        ref
            .read(selectedShoppingListItemsProvider.notifier)
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
              ListTile(
                selected: selectedItems.contains(shoppingListItem.item),
                contentPadding: EdgeInsets.only(right: 16),
                onLongPress: () =>
                    toggleItemToSelectedItems(shoppingListItem.item),
                onTap: selectedItems.isNotEmpty
                    ? () => toggleItemToSelectedItems(shoppingListItem.item)
                    : null,
                leading: Container(color: supermarketSection?.color, width: 6),
                minLeadingWidth: 6,
                trailing: selectedItems.isEmpty
                    ? Checkbox(
                        value: shoppingListItem.checked,
                        onChanged: onSubmitted,
                      )
                    : null,
                title: Row(
                  children: [
                    if (selectedItems.isEmpty)
                      Flexible(
                        flex: 1,
                        child: _buildQuantityChip(shoppingListItem),
                      ),
                    Flexible(
                      flex: 5,
                      child: ItemSuggestionTextField(
                        availableIngredients: availableIngredients,
                        value: model,
                        enabled: editable,
                        showShoppingItemSuggestions: false,
                        onSubmitted: onSubmitted,
                        textStyle: shoppingListItem.checked
                            ? TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey)
                            : null,
                      ),
                    ),
                    //some space to allow swipe to dismiss
                    Flexible(child: Container(), flex: 1),
                  ],
                ),
              ),
              Divider(height: 0)
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuantityChip(ShoppingListItem item) {
    var quantity = shoppingListItem.quantity ?? '-';
    var uom = shoppingListItem.quantity ?? '';
    return Chip(
        label: Text(
      "$quantity/$uom",
      style: TextStyle(fontSize: 12),
    ));
  }
}
