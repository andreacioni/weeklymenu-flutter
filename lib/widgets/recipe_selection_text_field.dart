import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

class RecipeSelectionTextField extends StatelessWidget {
  final List<String> _availableRecipes;
  final TextEditingController _typeAheadController =
      new TextEditingController();

  RecipeSelectionTextField(this._availableRecipes);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Recipe",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          width: 200,
          child: TypeAheadField(
            direction: AxisDirection.up,
            textFieldConfiguration:
                TextFieldConfiguration(controller: _typeAheadController),
            suggestionsCallback: (pattern) async {
              return _availableRecipes
                  .where((r) => r.toLowerCase().contains(pattern.toLowerCase()))
                  .toList();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
              this._typeAheadController.text = suggestion;
            },
          ),
        ),
      ],
    );
  }
}
