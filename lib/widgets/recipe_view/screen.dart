import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_data_state/flutter_data_state.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

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
  double spinner;

  @override
  void initState() {
    _editEnabled = false;
    spinner = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recipesRepo = context.watch<Repository<Recipe>>();

    return DataStateBuilder<Recipe>(
      notifier: () => recipesRepo.watchOne(widget.recipeId),
      builder: (context, state, notifier, _) {
        if (state.isLoading && !state.hasModel) {
          return Center(child: CircularProgressIndicator());
        }

        if (state.hasException && !state.hasModel) {
          return Text("Error occurred");
        }

        final recipe = RecipeOriginator(state.model);

        return WillPopScope(
          onWillPop: () async {
            _handleBackButton(context, recipe);
            return true;
          },
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async => notifier.reload(),
              child: buildForm(recipe),
            ),
          ),
        );
      },
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
                recipe.description,
                editEnabled: _editEnabled,
                hintText: "Description",
                onSubmitted: (newDescription) =>
                    recipe.updateDescription(newDescription),
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
              if (recipe.ingredients.isEmpty && !_editEnabled)
                EditableTextField(
                  "",
                  editEnabled: false,
                  hintText: "No ingredients",
                ),
              if (recipe.ingredients.isNotEmpty)
                ...recipe.ingredients
                    .map(
                      (recipeIng) => ChangeNotifierProvider.value(
                        value: recipeIng,
                        child: DismissibleRecipeIngredientTile(
                          recipe,
                          _editEnabled,
                        ),
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
                recipe.preparation,
                editEnabled: _editEnabled,
                hintText: "Add preparation steps...",
                maxLines: 1000,
                onChanged: (text) => recipe.updatePreparation(text),
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
                recipe.note,
                editEnabled: _editEnabled,
                hintText: "Add note...",
                maxLines: 1000,
                onChanged: (text) => recipe.updateNote(text),
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
        final r = await context.read<Repository<Recipe>>().save(recipe.save());
        print(r);
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
