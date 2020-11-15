import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_data_state/flutter_data_state.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../recipe_ingredient_modal/recipe_ingredient_modal.dart';
import '../../../models/ingredient.dart';
import '../../../models/recipe.dart';

class RecipeIngredientListTile extends StatelessWidget {
  final log = Logger();

  final RecipeOriginator _recipe;
  final RecipeIngredient recipeIngredient;
  final bool editEnabled;

  RecipeIngredientListTile(this._recipe, this.recipeIngredient,
      {this.editEnabled = false});

  @override
  Widget build(BuildContext context) {
    final ingredientsRepo = context.watch<Repository<Ingredient>>();
    return DataStateBuilder<Ingredient>(
      notifier: () => ingredientsRepo.watchOne(recipeIngredient.ingredientId),
      builder: (context, state, notifier, _) {
        if (state.hasException && !state.hasModel) {
          return Text("Error occurred");
        }

        if (state.isLoading && !state.hasModel) {
          return Center(child: CircularProgressIndicator());
        }

        final ingredient = state.model;
        return buildListTile(context, ingredient);
      },
    );
    /* return FutureBuilder<Ingredient>(
      future: Provider.of<Repository<Ingredient>>(context, listen: false)
          .findOne(widget._recipeIngredient.ingredientId, remote: false),
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
    ); */
  }

  Widget buildListTile(BuildContext context, Ingredient ingredient) {
    return Card(
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset("assets/icons/supermarket.png"),
        ),
        title: Text(ingredient.name == null ? '' : ingredient.name),
        trailing: editEnabled
            ? IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => openRecipeIngredientUpdateModal(context),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    recipeIngredient.quantity?.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    recipeIngredient.unitOfMeasure == null
                        ? '-'
                        : recipeIngredient.unitOfMeasure.toString(),
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

  void openRecipeIngredientUpdateModal(BuildContext context) async {
    RecipeIngredient updatedRecipeIng = await showDialog<RecipeIngredient>(
      context: context,
      barrierDismissible: true,
      builder: (_) => RecipeIngredientModal(
        recipeIngredient.recipeId,
        recipeIngredient: recipeIngredient,
      ),
    );

    if (updatedRecipeIng != null) {
      _recipe.setEdited();
      recipeIngredient.update(
        quantity: updatedRecipeIng.quantity,
        unitOfMeasure: updatedRecipeIng.unitOfMeasure,
        freezed: updatedRecipeIng.freezed,
      );
    } else {
      log.i("No update ingredient recipe returned");
    }
  }
}
