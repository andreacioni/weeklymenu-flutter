import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_menu_app/providers/providers.dart';
import 'package:weekly_menu_app/widgets/flutter_data_state_builder.dart';

import '../../globals/errors_handlers.dart';
import 'add_ingredient_button.dart';
import 'recipe_ingredient_tile/dismissible_recipe_ingredient.dart';
import 'recipe_information_tiles.dart';
import '../../models/recipe.dart';
import 'recipe_app_bar.dart';
import 'recipe_tags.dart';
import 'editable_text_field.dart';

class RecipeView extends StatefulWidget {
  final String recipeId;
  final Object heroTag;

  RecipeView(this.recipeId, {this.heroTag});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  final _log = Logger();
  final _formKey = GlobalKey<FormState>();

  bool _editEnabled;

  @override
  void initState() {
    _editEnabled = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, _) {
          final recipe = watch(recipeOriginatorProvider(widget.recipeId));
          return recipe != null
              ? WillPopScope(
                  onWillPop: () async {
                    _handleBackButton(context, recipe);
                    return true;
                  },
                  child: buildForm(recipe),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  Form buildForm(RecipeOriginator recipe) {
    return Form(
      key: _formKey,
      child: CustomScrollView(
        slivers: <Widget>[
          RecipeAppBar(
            recipe,
            heroTag: widget.heroTag,
            editModeEnabled: _editEnabled,
            onRecipeEditEnabled: (editEnabled) =>
                _handleEditToggle(recipe, editEnabled),
            onBackPressed: () => _handleBackButton(context, recipe),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 5,
              ),
              EditableTextField(
                recipe.instance.description,
                editEnabled: _editEnabled,
                hintText: "Description",
                onSubmitted: (newDescription) => recipe.update(
                    recipe.instance.copyWith(description: newDescription)),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "Information",
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: RecipeInformationTiles(
                    recipe,
                    editEnabled: _editEnabled,
                    formKey: _formKey,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "Ingredients",
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              if (recipe.instance.ingredients.isEmpty && !_editEnabled)
                EditableTextField(
                  "",
                  editEnabled: false,
                  hintText: "No ingredients",
                ),
              if (recipe.instance.ingredients.isNotEmpty)
                ...recipe.instance.ingredients
                    .map(
                      (recipeIng) => DismissibleRecipeIngredientTile(
                        recipe,
                        recipeIng,
                        _editEnabled,
                      ),
                    )
                    .toList(),
              if (_editEnabled)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AddIngredientButton(recipe),
                ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "Prepation",
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              EditableTextField(
                recipe.instance.preparation,
                editEnabled: _editEnabled,
                hintText: "Add preparation steps...",
                maxLines: 1000,
                onChanged: (text) =>
                    recipe.update(recipe.instance.copyWith(preparation: text)),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "Notes",
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              EditableTextField(
                recipe.instance.note,
                editEnabled: _editEnabled,
                hintText: "Add note...",
                maxLines: 1000,
                onChanged: (text) =>
                    recipe.update(recipe.instance.copyWith(note: text)),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "Tags",
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              RecipeTags(
                recipe: recipe,
                editEnabled: _editEnabled,
              ),
              SizedBox(
                height: 5,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _handleEditToggle(RecipeOriginator recipe, bool editEnabled) async {
    if (!_formKey.currentState.validate()) {
      _log.w("Validation faield");
      return;
    }

    //This call save the form's state not the recipe. This operation must be done
    // here to trigger all the onSaved callback of the form fields
    _formKey.currentState.save();

    if (!editEnabled && recipe.isEdited) {
      //When switching from 'editEnabled = true' to 'editEnabled = false' means we must update resource on remote (if needed)

      _log.i("Saving all recipe changes");

      showProgressDialog(context);

      try {
        await context.read(recipesRepositoryProvider).save(recipe.save());
      } catch (e) {
        showAlertErrorMessage(context);
        return;
      } finally {
        hideProgressDialog(context);
      }
    }
    setState(() => _editEnabled = editEnabled);
  }

  void _handleBackButton(BuildContext context, RecipeOriginator recipe) async {
    if (recipe.isEdited) {
      final wannaSave = await showWannaSaveDialog(context);

      if (wannaSave) {
        _handleEditToggle(recipe, false);
      } else {
        _log.i("Losing all the changes");
        recipe.revert();
      }
    } else {
      _log.d("No changes made, not save action is necessary");
    }

    Navigator.of(context).pop();
  }
}
