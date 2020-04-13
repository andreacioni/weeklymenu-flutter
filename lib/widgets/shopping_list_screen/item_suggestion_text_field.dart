import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../globals/utils.dart';
import '../../models/ingredient.dart';
import '../../models/shopping_list.dart';
import '../../providers/ingredients_provider.dart';
import '../../providers/shopping_list_provider.dart';

class ItemSuggestionTextField extends StatefulWidget {
  final Ingredient value;
  final String hintText;
  final FocusNode focusNode;
  final bool autofocus;
  final bool showShoppingItemSuggestions;
  final void Function(Ingredient) onIngredientSelected;
  final void Function(ShoppingListItem) onShoppingItemSelected;
  final void Function(dynamic) onSubmitted;
  final Function onTap;
  final Function(bool) onFocusChanged;

  ItemSuggestionTextField({
    this.value,
    this.onIngredientSelected,
    this.onShoppingItemSelected,
    this.onSubmitted,
    this.showShoppingItemSuggestions = true,
    this.onTap,
    this.onFocusChanged,
    this.hintText,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  _ItemSuggestionTextFieldState createState() =>
      _ItemSuggestionTextFieldState();
}

class _ItemSuggestionTextFieldState extends State<ItemSuggestionTextField> {
  FocusNode focusNode;

  @override
  void initState() {
    if (widget.focusNode != null) {
      focusNode = widget.focusNode;
    } else {
      focusNode = FocusNode();
    }

    focusNode.addListener(() => widget.onFocusChanged(focusNode.hasFocus));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    if (widget.value != null) {
      textEditingController.text = widget.value.name;
    }
    return TypeAheadField<dynamic>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: textEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
        ),
        onSubmitted: widget.onSubmitted,
        onTap: focusNode.hasFocus ? widget.onTap : null,
        focusNode: focusNode,
        autofocus: widget.autofocus,
      ),
      itemBuilder: _itemBuilder,
      onSuggestionSelected: (suggestion) =>
          _onSuggestionSelected(textEditingController, suggestion),
      suggestionsCallback: (pattern) => _suggestionsCallback(context, pattern),
      hideOnEmpty: true,
    );
  }

  void _onSuggestionSelected(
      TextEditingController textEditingController, dynamic item) {
    if (item is Ingredient) {
      textEditingController.text = item.name;

      if (widget.onIngredientSelected != null) {
        widget.onIngredientSelected(item);
      }
    } else {
      var ingredient = _resolveShoppingListItemIngredient(item);
      textEditingController.text = ingredient.name;

      if (widget.onShoppingItemSelected != null) {
        widget.onShoppingItemSelected(item);
      }
    }
  }

  Future<List> _suggestionsCallback(
      BuildContext context, String pattern) async {
    final ingredientProvider = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    );
    final availableIngredients = ingredientProvider.getIngredients;

    List<dynamic> suggestions = [];

    if (widget.showShoppingItemSuggestions) {
      final checkedItems = Provider.of<ShoppingListProvider>(
        context,
        listen: false,
      ).getCheckedItems.where((item) {
        var ing = ingredientProvider.getById(item.item);
        return ing != null ? stringContains(ing.name, pattern) : false;
      });
      suggestions.addAll(checkedItems);
    }

    suggestions.addAll(availableIngredients
        .where((ing) => stringContains(ing.name, pattern))
        .toList());

    return suggestions;
  }

  Widget _itemBuilder(BuildContext buildContext, dynamic item) {
    if (item is Ingredient) {
      return ListTile(
        title: Text(item.name),
        subtitle: Text('Igredient'),
      );
    } else {
      var ing = _resolveShoppingListItemIngredient(item);
      return ListTile(
        title: Text(ing.name),
        subtitle: Text('Shopping List'),
        trailing: Icon(Icons.check_box),
      );
    }
  }

  Ingredient _resolveShoppingListItemIngredient(
      ShoppingListItem shoppingListItem) {
    return Provider.of<IngredientsProvider>(
      context,
      listen: false,
    ).getById(shoppingListItem.item);
  }
}
