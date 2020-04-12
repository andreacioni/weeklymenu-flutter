import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/ingredients_provider.dart';
import '../../models/shopping_list.dart';
import '../../models/ingredient.dart';
import './item_suggestion_text_field.dart';

class ShoppingListItemTile extends StatefulWidget {
  final ShoppingListItem shoppingListItem;
  final Function(bool) onCheckChange;

  ShoppingListItemTile(this.shoppingListItem,
      {Key key, this.onCheckChange})
      : super(key: key);

  @override
  _ShoppingListItemTileState createState() => _ShoppingListItemTileState();
}

class _ShoppingListItemTileState extends State<ShoppingListItemTile> {
  Ingredient _ingredient;
  bool _editingMode;

  @override
  void initState() {
    _editingMode = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.shoppingListItem.item != null) {
      _ingredient = Provider.of<IngredientsProvider>(context)
          .getById(widget.shoppingListItem.item);
    } else {
      _editingMode = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.menu),
          trailing: _editingMode == true
              ? IconButton(icon: Icon(Icons.edit), onPressed: null)
              : Checkbox(
                  value: widget.shoppingListItem.checked,
                  onChanged: onCheckChange,
                ),
          title: ItemSuggestionTextField(
            value: _ingredient,
            onSuggestionSelected: _onSuggestionSelected,
            onSubmitted: _getOrCreateIngredientByName,
            onTap: _onTap,
            onFocusChanged: _onFocusChanged,
          ),
        ),
        Divider()
      ],
    );
  }

  void _onFocusChanged(bool hasFocus) {
    if (hasFocus == false) {
      setState(() {
        _editingMode = false;
      });
    }
  }

  void _onTap() {
    setState(() {
      _editingMode = true;
    });
  }

  void _onSuggestionSelected(Ingredient newIngredient) {
    setState(() {
      _ingredient = newIngredient;
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
      widget.onCheckChange(newValue);
    }
  }
}
