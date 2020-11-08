import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:provider/provider.dart';

import '../../models/shopping_list.dart';
import '../../models/ingredient.dart';
import './item_suggestion_text_field.dart';

class ShoppingListItemTile extends StatefulWidget {
  final Key formKey;
  final ShoppingListItem shoppingListItem;
  final Function(bool) onCheckChange;
  final Function(DismissDirection) onDismiss;
  final bool editable;

  ShoppingListItemTile(
    this.shoppingListItem, {
    this.formKey,
    this.onCheckChange,
    this.onDismiss,
    this.editable = true,
  }) : super(key: formKey);

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
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Repository<Ingredient>>(context, listen: false)
          .findOne(widget.shoppingListItem.item),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error occurred");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

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
                  value: _ingredient,
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
