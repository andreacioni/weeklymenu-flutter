import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    final _editingMode = useState(false);
    final shopItem = useState(shoppingListItem);

    void _onFocusChanged(bool hasFocus) {
      if (hasFocus == false) {
        _editingMode.value = false;
      } else {
        _editingMode.value = true;
      }
    }

    void _onIngredientSelected(Ingredient newIngredient) {
      _editingMode.value = false;
    }

    void _getOrCreateIngredientByName(ingredientName) {
      _editingMode.value = false;
    }

    void _onCheckChange(newValue) {
      shopItem.value = shopItem.value.copyWith(checked: newValue);

      if (onCheckChange != null) {
        onCheckChange!(newValue);
      }
    }

    return FlutterDataStateBuilder<Ingredient>(
      state: ingredientsRepository.watchOne(shoppingListItem.item),
      onRefresh: () => ingredientsRepository.findOne(shoppingListItem.item),
      builder: (context, model) {
        return Dismissible(
          key: formKey,
          onDismissed: onDismiss,
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(right: 16),
                leading: Container(color: Colors.red, width: 6),
                trailing: _editingMode.value == true
                    ? IconButton(icon: Icon(Icons.edit), onPressed: null)
                    : Checkbox(
                        value: shoppingListItem.checked,
                        onChanged: _onCheckChange,
                      ),
                title: ItemSuggestionTextField(
                  value: model,
                  enabled: editable,
                  showShoppingItemSuggestions: false,
                  onIngredientSelected: _onIngredientSelected,
                  onSubmitted: _getOrCreateIngredientByName,
                  //onTap: _onTap,
                  onFocusChanged: _onFocusChanged,
                ),
              ),
              Divider(
                height: 0,
              )
            ],
          ),
        );
      },
    );
  }
}
