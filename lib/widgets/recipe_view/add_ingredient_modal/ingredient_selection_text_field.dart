import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../models/ingredient.dart';

class IngredientSelectionTextField extends StatefulWidget {
  final Function onIngredientSelected;
  final List<Ingredient> _availableIngredients;

  IngredientSelectionTextField(this._availableIngredients,
      {this.onIngredientSelected});

  @override
  _IngredientSelectionTextFieldState createState() =>
      _IngredientSelectionTextFieldState();
}

class _IngredientSelectionTextFieldState
    extends State<IngredientSelectionTextField> {
  final TextEditingController _typeAheadController =
      new TextEditingController();

  List<Ingredient> getIngredientsSuggestion(String pattern) {
    var suggestions = widget._availableIngredients
        .where((r) =>
            r.name.toLowerCase().trim().contains(pattern.trim().toLowerCase()))
        .toList();

    if (pattern.trim() != "" &&
        widget._availableIngredients.indexWhere((r) =>
                r.name.trim().toLowerCase() == pattern.trim().toLowerCase()) ==
            -1) {
      suggestions.add(
          Ingredient(id: 'NONE', name: "Add ${_typeAheadController.text} ..."));
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TypeAheadField<Ingredient>(
            direction: AxisDirection.down,
            textFieldConfiguration: TextFieldConfiguration(
              controller: _typeAheadController,
              decoration: InputDecoration(
                hintText: "Ingredient",
              ),
            ),
            suggestionsCallback: (pattern) async {
              return getIngredientsSuggestion(pattern);
            },
            itemBuilder: (context, ingredient) {
              return ListTile(
                trailing: Icon(Icons.call_made),
                title: Text(ingredient.name),
              );
            },
            noItemsFoundBuilder: (_) {
              return ListTile(
                title: Text("Type a new ingredient name"),
              );
            },
            onSuggestionSelected: (selectedIngredient) {
              if (selectedIngredient.id == 'NONE') {
                print('Add Ingredient: ${selectedIngredient.name}');
                selectedIngredient.name = RegExp(r"^Add (.*) \.\.\.")
                    .firstMatch(selectedIngredient.name)
                    .group(1);
              } else {
                this._typeAheadController.text = selectedIngredient.name;

                widget.onIngredientSelected(selectedIngredient);
              }
            },
          ),
        ),
      ],
    );
  }
}
