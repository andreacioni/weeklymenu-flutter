import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../flutter_data_state_builder.dart';
import '../../models/shopping_list.dart';
import '../../models/ingredient.dart';
import './item_suggestion_text_field.dart';

class ShoppingListItemTile extends StatefulWidget {
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
  _ShoppingListItemTileState createState() => _ShoppingListItemTileState();
}

class _ShoppingListItemTileState extends State<ShoppingListItemTile> {
  late final bool _editingMode;

  @override
  void initState() {
    _editingMode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final ingredientsRepository = ref.watch(ingredientsRepositoryProvider);
        return FlutterDataStateBuilder(
          notifier: () =>
              ingredientsRepository.watchOne(widget.shoppingListItem.item),
          builder: (context, state, notifier, _) {
            return Dismissible(
              key: widget.formKey,
              onDismissed: widget.onDismiss,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.drag_handle),
                    trailing: _editingMode == true
                        ? IconButton(icon: Icon(Icons.edit), onPressed: null)
                        : Checkbox(
                            value: widget.shoppingListItem.checked,
                            onChanged: onCheckChange,
                          ),
                    title: ItemSuggestionTextField(
                      value: state.model,
                      enabled: widget.editable,
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
      },
    );
  }

  void _onFocusChanged(bool hasFocus) {
    if (hasFocus == false) {
      setState(() {
        _editingMode = false;
      });
    } else {
      setState(() {
        _editingMode = true;
      });
    }
  }

  void _onIngredientSelected(Ingredient newIngredient) {
    setState(() {
      _editingMode = false;
    });
  }

  void _getOrCreateIngredientByName(ingredientName) {
    setState(() {
      _editingMode = false;
    });
  }

  void onCheckChange(newValue) {
    setState(() {
      widget.shoppingListItem.checked = newValue;
    });

    if (widget.onCheckChange != null) {
      widget.onCheckChange!(newValue);
    }
  }
}
