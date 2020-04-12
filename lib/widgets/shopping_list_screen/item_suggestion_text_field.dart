import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../models/ingredient.dart';
import '../../providers/ingredients_provider.dart';

class ItemSuggestionTextField extends StatefulWidget {
  final Ingredient value;
  final String hintText;
  final FocusNode focusNode;
  final bool autofocus;
  final void Function(Ingredient) onSuggestionSelected;
  final void Function(dynamic) onSubmitted;
  final Function onTap;
  final Function(bool) onFocusChanged;

  ItemSuggestionTextField({
    this.value,
    this.onSuggestionSelected,
    this.onSubmitted,
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
    return TypeAheadField<Ingredient>(
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
      onSuggestionSelected: (ingredient) => _onSuggestionSelected,
      suggestionsCallback: (pattern) => _suggestionsCallback(context, pattern),
      hideOnEmpty: true,
    );
  }

  void _onSuggestionSelected(TextEditingController textEditingController,
      Ingredient selectedIngredient) {
    textEditingController.text = selectedIngredient.name;

    if (widget.onSuggestionSelected != null) {
      widget.onSuggestionSelected(selectedIngredient);
    }
  }

  Future<List<Ingredient>> _suggestionsCallback(
      BuildContext context, String pattern) async {
    final availableIngredients = Provider.of<IngredientsProvider>(
      context,
      listen: false,
    ).getIngredients;

    var suggestions = availableIngredients
        .where((r) =>
            r.name.toLowerCase().trim().contains(pattern.trim().toLowerCase()))
        .toList();

    return suggestions;
  }

  Widget _itemBuilder(
      BuildContext buildContext, Ingredient selectedIngredient) {
    return ListTile(title: Text(selectedIngredient.name));
  }
}
