import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../../models/ingredient.dart';

class IngredientSelectionTextField extends StatefulWidget {
  final Function(Ingredient) onIngredientSelected;
  final Function(String) onSubmitted;
  final Ingredient value;
  final bool enabled;
  final bool autofocus;

  IngredientSelectionTextField(
      {@required this.onIngredientSelected,
      this.onSubmitted,
      this.value,
      this.enabled = true,
      this.autofocus = false});

  @override
  _IngredientSelectionTextFieldState createState() =>
      _IngredientSelectionTextFieldState();
}

class _IngredientSelectionTextFieldState
    extends State<IngredientSelectionTextField> {
  final TextEditingController _typeAheadController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      _typeAheadController.text = widget.value.name;
    }

    return TypeAheadField<Ingredient>(
      direction: AxisDirection.down,
      textFieldConfiguration: TextFieldConfiguration(
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          controller: _typeAheadController,
          decoration: InputDecoration(
            labelText: "Ingredient",
            enabled: widget.enabled,
          ),
          onSubmitted: (text) {}),
      suggestionsCallback: (pattern) async {
        return getIngredientsSuggestion(pattern);
      },
      itemBuilder: (context, ingredient) {
        return ListTile(
          trailing: Icon(ingredient.id == null ? Icons.add : Icons.call_made),
          title: Text(ingredient.name),
        );
      },
      noItemsFoundBuilder: (_) {
        return ListTile(
          title: Text("Type a new ingredient name"),
        );
      },
      onSuggestionSelected: (selectedIngredient) {
        if (selectedIngredient.id == null) {
          selectedIngredient.name = RegExp(r'^Add "(.*)" \.\.\.')
              .firstMatch(selectedIngredient.name)
              .group(1);
          print('Add Ingredient: ${selectedIngredient.name}');
        } else {
          this._typeAheadController.text = selectedIngredient.name;
        }

        widget.onIngredientSelected(selectedIngredient);
      },
    );
  }

  Future<List<Ingredient>> getIngredientsSuggestion(String pattern) async {
    final availableIngredients = await Provider.of<Repository<Ingredient>>(
      context,
      listen: false,
    ).findAll();

    var suggestions = availableIngredients
        .where((r) =>
            r.name.toLowerCase().trim().contains(pattern.trim().toLowerCase()))
        .toList();

    if (pattern.trim() != "" &&
        availableIngredients.indexWhere((r) =>
                r.name.trim().toLowerCase() == pattern.trim().toLowerCase()) ==
            -1) {
      suggestions
          .add(Ingredient(name: 'Add "${_typeAheadController.text}" ...'));
    }

    return suggestions;
  }

  Widget buildAddIngredientIconButton(Ingredient selectedIngredient) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        _typeAheadController.clear();
        widget.onIngredientSelected(selectedIngredient);
      },
    );
  }
}
