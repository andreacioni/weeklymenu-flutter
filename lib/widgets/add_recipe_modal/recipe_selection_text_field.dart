import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

class RecipeSelectionTextField extends StatefulWidget {
  final List<String> _availableRecipes = [
    "Pici aglio e olio",
    "Spaghetti alla matriciana",
    "Uovo sodo"
  ];
  final Function onRecipeSelected;
  final List<String> _alreadySelectedRecipes;

  RecipeSelectionTextField(this._alreadySelectedRecipes,
      {this.onRecipeSelected});

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

    //Remove recipes already selected
    suggestions.removeWhere((r) => widget._alreadySelectedRecipes.contains(r));

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

  Widget buildAddRecipeIconButton(String suggestion) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        _typeAheadController.clear();
        clearTrailingTextFieldButton();
        widget.onRecipeSelected(suggestion);
      },
    );
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
                trailing: Icon(Icons.shop),
                title: Text(suggestion),
              );
            },
            noItemsFoundBuilder: (_) {
              return Text("Type a new recipe name");
            },
            onSuggestionSelected: (suggestion) {
              if (suggestion == addNewRecipeSuggestion) {
                print("Add recipe!");
              } else {
                this._typeAheadController.text = suggestion;
                setState(() {
                  trailingTextFieldButton =
                      buildAddRecipeIconButton(suggestion);
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
