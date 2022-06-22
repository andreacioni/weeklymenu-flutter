import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';

import '../../globals/utils.dart';
import '../../models/ingredient.dart';
import '../../models/shopping_list.dart';

class ItemSuggestionTextField extends StatefulWidget {
  final Ingredient? value;
  final String? hintText;
  final bool autoFocus;
  final bool showShoppingItemSuggestions;
  final void Function(Ingredient)? onIngredientSelected;
  final void Function(ShoppingListItem)? onShoppingItemSelected;
  final void Function(dynamic)? onSubmitted;
  final Function()? onTap;
  final Function(bool) onFocusChanged;
  final bool enabled;
  final TextStyle? textStyle;

  ItemSuggestionTextField({
    this.value,
    this.onIngredientSelected,
    this.onShoppingItemSelected,
    this.onSubmitted,
    this.showShoppingItemSuggestions = true,
    this.onTap,
    this.autoFocus = false,
    this.enabled = true,
    required this.onFocusChanged,
    this.hintText,
    this.textStyle,
  });

  @override
  _ItemSuggestionTextFieldState createState() =>
      _ItemSuggestionTextFieldState();
}

class _ItemSuggestionTextFieldState extends State<ItemSuggestionTextField> {
  List<Ingredient> availableIngredients = [];
  late final FocusNode focusNode;

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
    if (widget.value?.name != null) {
      textEditingController.text = widget.value!.name;
    }
    return Consumer(builder: (context, ref, _) {
      if (widget.enabled)
        return TypeAheadField<dynamic>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: textEditingController,
            enabled: widget.enabled,
            style: widget.textStyle,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
            ),
            onSubmitted: widget.onSubmitted,
            onTap: focusNode.hasFocus ? widget.onTap : null,
            focusNode: focusNode,
            autofocus: widget.autoFocus,
          ),
          itemBuilder: itemBuilder,
          onSuggestionSelected: (suggestion) =>
              onSuggestionSelected(textEditingController, suggestion),
          suggestionsCallback: (pattern) => suggestionsCallback(ref, pattern),
          hideOnEmpty: true,
        );
      else
        return Text(
          widget.value?.name ?? '',
          style: widget.textStyle,
        );
    });
  }

  void onSuggestionSelected(
      TextEditingController textEditingController, dynamic item) {
    if (item is Ingredient) {
      textEditingController.text = item.name;

      if (widget.onIngredientSelected != null) {
        widget.onIngredientSelected!(item);
      }
    } else {
      var ingredient = resolveShoppingListItemIngredient(item);
      textEditingController.text = ingredient?.name ?? 'Ingredient not found';

      if (widget.onShoppingItemSelected != null) {
        widget.onShoppingItemSelected!(item);
      }
    }
  }

  Future<List> suggestionsCallback(WidgetRef ref, String pattern) async {
    final ingredientsRepo = ref.read(ingredientsRepositoryProvider);
    final shopListRepo = ref.read(shoppingListsRepositoryProvider);

    availableIngredients = await ingredientsRepo.findAll(remote: false) ?? [];

    List<dynamic> suggestions = [];

    if (widget.showShoppingItemSuggestions) {
      final shoppingList = (await shopListRepo.findAll(remote: false))![0];

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
        subtitle: Text('Ingredient'),
      );
    } else {
      var ing = resolveShoppingListItemIngredient(item);
      return ListTile(
        title: Text(ing?.name ?? 'Ingredient not found'),
        subtitle: Text('Shopping List'),
        trailing: Icon(Icons.check_box),
      );
    }
  }

  Ingredient? resolveShoppingListItemIngredient(ShoppingListItem item) {
    return availableIngredients
        .firstWhereOrNull((ingredient) => ingredient.id == item.item);
  }
}
