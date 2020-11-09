import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../globals/utils.dart';
import '../../models/ingredient.dart';
import '../../models/shopping_list.dart';

class ItemSuggestionTextField extends StatefulWidget {
  final Ingredient value;
  final String hintText;
  final bool autofocus;
  final bool showShoppingItemSuggestions;
  final void Function(Ingredient) onIngredientSelected;
  final void Function(ShoppingListItem) onShoppingItemSelected;
  final void Function(dynamic) onSubmitted;
  final Function onTap;
  final Function(bool) onFocusChanged;
  final bool enabled;

  ItemSuggestionTextField({
    this.value,
    this.onIngredientSelected,
    this.onShoppingItemSelected,
    this.onSubmitted,
    this.showShoppingItemSuggestions = true,
    this.onTap,
    this.onFocusChanged,
    this.hintText,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  _ItemSuggestionTextFieldState createState() =>
      _ItemSuggestionTextFieldState();
}

class _ItemSuggestionTextFieldState extends State<ItemSuggestionTextField> {
  List<Ingredient> availableIngredients = [];
  FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.addListener(() => widget.onFocusChanged(focusNode.hasFocus));
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
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
        enabled: widget.enabled,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
        ),
        onSubmitted: widget.onSubmitted,
        onTap: focusNode.hasFocus ? widget.onTap : null,
        focusNode: focusNode,
        autofocus: widget.autofocus,
      ),
      itemBuilder: itemBuilder,
      onSuggestionSelected: (suggestion) =>
          onSuggestionSelected(textEditingController, suggestion),
      suggestionsCallback: (pattern) => suggestionsCallback(context, pattern),
      hideOnEmpty: true,
    );
  }

  void onSuggestionSelected(
      TextEditingController textEditingController, dynamic item) {
    if (item is Ingredient) {
      textEditingController.text = item.name;

      if (widget.onIngredientSelected != null) {
        widget.onIngredientSelected(item);
      }
    } else {
      var ingredient = resolveShoppingListItemIngredient(item);
      textEditingController.text = ingredient.name;

      if (widget.onShoppingItemSelected != null) {
        widget.onShoppingItemSelected(item);
      }
    }
  }

  Future<List> suggestionsCallback(BuildContext context, String pattern) async {
    final ingredientProvider = Provider.of<Repository<Ingredient>>(
      context,
      listen: false,
    );
    availableIngredients = await ingredientProvider.findAll();

    List<dynamic> suggestions = [];

    if (widget.showShoppingItemSuggestions) {
      final shoppingList = Provider.of<ShoppingList>(
        context,
        listen: false,
      );
      final checkedItems = shoppingList.getCheckedItems.where((item) {
        var ing = resolveShoppingListItemIngredient(item);
        return ing != null ? stringContains(ing.name, pattern) : false;
      });

      suggestions.addAll(checkedItems);
      suggestions.addAll(availableIngredients
          .where((ing) =>
              stringContains(ing.name, pattern) &&
              shoppingList.containsItem(ing.id) == false)
          .toList());
    } else {
      suggestions.addAll(availableIngredients
          .where((ing) => stringContains(ing.name, pattern))
          .toList());
    }

    return suggestions;
  }

  Widget itemBuilder(BuildContext buildContext, dynamic item) {
    if (item is Ingredient) {
      return ListTile(
        title: Text(item.name),
        subtitle: Text('Igredient'),
      );
    } else {
      var ing = resolveShoppingListItemIngredient(item);
      return ListTile(
        title: Text(ing.name),
        subtitle: Text('Shopping List'),
        trailing: Icon(Icons.check_box),
      );
    }
  }

  Ingredient resolveShoppingListItemIngredient(ShoppingListItem item) {
    return availableIngredients.firstWhere(
        (ingredient) => ingredient.id == item.item,
        orElse: () => null);
  }
}
