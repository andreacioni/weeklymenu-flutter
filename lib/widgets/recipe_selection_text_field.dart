import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

class RecipeSelectionTextField extends StatefulWidget {
  final List<String> _availableRecipes;
  final Function _selectedRecipesCallback;

  RecipeSelectionTextField(
      this._availableRecipes, this._selectedRecipesCallback);

  @override
  _RecipeSelectionTextFieldState createState() =>
      _RecipeSelectionTextFieldState();
}

class _RecipeSelectionTextFieldState extends State<RecipeSelectionTextField> {
  final TextEditingController _typeAheadController =
      new TextEditingController();

  Widget trailingTextFieldButton = null;

  String get addNewRecipeSuggestion => "Add ${_typeAheadController.text} ...";

  List<String> getRecipesSuggestion(String pattern) {
    var suggestions = widget._availableRecipes
        .where((r) =>
            r.toLowerCase().trim().contains(pattern.trim().toLowerCase()))
        .toList();

    if (pattern.trim() != "") {
      suggestions.add(addNewRecipeSuggestion);
    }

    return suggestions.reversed.toList();
  }

  void clearTrailingTextFieldButton() {
    setState(() {
      trailingTextFieldButton = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TypeAheadField(
            direction: AxisDirection.up,
            getImmediateSuggestions: true,
            textFieldConfiguration: TextFieldConfiguration(
              controller: _typeAheadController,
              decoration: InputDecoration(
                hintText: "Recipe",
                suffixIcon: trailingTextFieldButton,
              ),
              onChanged: (_) => clearTrailingTextFieldButton(),
            ),
            suggestionsCallback: (pattern) async {
              return getRecipesSuggestion(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
              if (suggestion == addNewRecipeSuggestion) {
                print("Add recipe!");
              } else {
                this._typeAheadController.text = suggestion;
                setState(() {
                  trailingTextFieldButton = IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _typeAheadController.clear();
                      clearTrailingTextFieldButton();
                      widget._selectedRecipesCallback(suggestion);
                    },
                  );
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
