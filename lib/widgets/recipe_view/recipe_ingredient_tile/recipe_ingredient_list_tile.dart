import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../recipe_ingredient_modal/recipe_ingredient_modal.dart';
import '../../../models/ingredient.dart';
import '../../../models/recipe.dart';

class RecipeIngredientListTile extends StatefulWidget {
  final RecipeOriginator _recipe;
  final RecipeIngredient _recipeIngredient;
  final bool editEnabled;

  RecipeIngredientListTile(this._recipe, this._recipeIngredient,
      {this.editEnabled = false});

  @override
  _RecipeIngredientListTileState createState() =>
      _RecipeIngredientListTileState();
}

class _RecipeIngredientListTileState extends State<RecipeIngredientListTile> {
  final _log = Logger();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Ingredient>(
      future: Provider.of<Repository<Ingredient>>(context, listen: false)
          .findOne(widget._recipeIngredient.ingredientId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error occurred");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final ingredient = snapshot.data;

        return buildListTile(ingredient);
      },
    );
  }

  Widget buildListTile(Ingredient ingredient) {
    return Card(
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset("assets/icons/supermarket.png"),
        ),
        title: Text(ingredient.name == null ? '' : ingredient.name),
        trailing: widget.editEnabled
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: openRecipeIngredientUpdateModal,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget._recipeIngredient.quantity?.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget._recipeIngredient.unitOfMeasure == null
                        ? '-'
                        : widget._recipeIngredient.unitOfMeasure.toString(),
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

  void openRecipeIngredientUpdateModal() async {
    RecipeIngredient updatedRecipeIng = await showDialog<RecipeIngredient>(
      context: context,
      barrierDismissible: true,
      builder: (_) => RecipeIngredientModal(
        widget._recipeIngredient.recipeId,
        recipeIngredient: widget._recipeIngredient,
      ),
    );

    if (updatedRecipeIng != null) {
      widget._recipe.setEdited();
      widget._recipeIngredient.update(
        quantity: updatedRecipeIng.quantity,
        unitOfMeasure: updatedRecipeIng.unitOfMeasure,
        freezed: updatedRecipeIng.freezed,
      );
    } else {
      _log.i("No update ingredient recipe returned");
    }
  }
}
