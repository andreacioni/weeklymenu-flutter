import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

class RecipeSelectionTextField extends StatefulWidget {
  final List<String> _availableRecipes;

  RecipeSelectionTextField(this._availableRecipes);

  @override
  _RecipeSelectionTextFieldState createState() =>
      _RecipeSelectionTextFieldState();
}

class _RecipeSelectionTextFieldState extends State<RecipeSelectionTextField> {
  final TextEditingController _typeAheadController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TypeAheadField(
            direction: AxisDirection.up,
            textFieldConfiguration: TextFieldConfiguration(
              controller: _typeAheadController,
              decoration: InputDecoration(
                  hintText: "Recipe",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {},
                  )),
            ),
            suggestionsCallback: (pattern) async {
              return widget._availableRecipes
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
