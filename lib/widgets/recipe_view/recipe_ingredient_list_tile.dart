import 'package:flutter/material.dart';
import 'package:weekly_menu_app/models/ingredient.dart';

class RecipeIngredientListTile extends StatelessWidget {
  final RecipeIngredient _recipeIngredient;
  final bool editEnabled;

  RecipeIngredientListTile(this._recipeIngredient, {this.editEnabled = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset("assets/icons/supermarket.png"),
        ),
        title: Text(_recipeIngredient.name),
        trailing: editEnabled
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {},
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _recipeIngredient.quantity.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    _recipeIngredient.unitOfMeasure,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
