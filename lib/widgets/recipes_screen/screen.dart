import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:objectid/objectid.dart';

import '../../globals/constants.dart';
import '../../main.data.dart';
import '../flutter_data_state_builder.dart';
import '../../globals/errors_handlers.dart';
import '../recipe_view/screen.dart';
import '../../globals/utils.dart';
import '../../models/recipe.dart';
import './recipe_card.dart';
import '../../presentation/custom_icons_icons.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  late bool _searchModeEnabled;
  late String _searchText;

  late bool _editingModeEnabled;
  late List<Recipe> _selectedRecipes;

  @override
  void initState() {
    _searchModeEnabled = false;
    _searchText = "";
    _editingModeEnabled = false;
    _selectedRecipes = <Recipe>[];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final repository = ref.recipes;
      return Scaffold(
        appBar: _editingModeEnabled == false
            ? _buildAppBar(context)
            : _buildEditingAppBar(ref),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showRecipeNameDialog(ref),
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: buildDataStateBuilder(repository),
      );
    });
  }

  FlutterDataStateBuilder<List<Recipe>> buildDataStateBuilder(
      Repository<Recipe> repository) {
    return FlutterDataStateBuilder<List<Recipe>>(
      state: repository.watchAll(syncLocal: true),
      onRefresh: () => repository.findAll(syncLocal: true),
      builder: (context, model) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: _buildScreenBody(
            [...model],
            filter: (recipe) => !stringContains(recipe.name, _searchText),
          ),
        );
      },
    );
  }

  Widget _buildScreenBody(List<Recipe> recipes,
      {required bool Function(Recipe) filter}) {
    if (recipes.isNotEmpty) {
      recipes.removeWhere(filter);

      if (recipes.isEmpty && _searchModeEnabled) {
        return _buildNoRecipesFound(
          'Recipe "$_searchText" not found...',
          CustomIcons.not_found_lens,
        );
      } else {
        return _buildRecipeList(recipes);
      }
    } else {
      return _buildNoRecipesFound(
        "No recipes defined\nLet's add your first!",
        Icons.add_circle,
      );
    }
  }

  Widget _buildNoRecipesFound(String text, IconData icon) {
    final _textColor = Colors.grey.shade300;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 130,
            color: _textColor,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: _textColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecipeList(List<Recipe> recipes) {
    return GridView.builder(
      cacheExtent: 2000,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (ctx, index) => Hero(
        tag: recipes[index].id,
        child: buildRecipeCard(recipes, index, ctx),
      ),
      itemCount: recipes.length,
    );
  }

  Widget buildRecipeCard(List<Recipe> recipes, int index, BuildContext ctx) {
    final recipe = recipes[index];
    return RecipeCard(
      recipe.id,
      borderSide: _editingModeEnabled == true &&
              _selectedRecipes.contains(recipes[index])
          ? BorderSide(color: Theme.of(ctx).colorScheme.secondary, width: 2)
          : BorderSide.none,
      shadowColorStart: _editingModeEnabled == true &&
              _selectedRecipes.contains(recipes[index])
          ? Theme.of(ctx).colorScheme.secondary.withOpacity(0.7)
          : Colors.black54,
      onTap: () => _editingModeEnabled == true
          ? _addRecipeToEditingList(recipe)
          : _openRecipeView(recipe, recipe.id),
      onLongPress: () =>
          _editingModeEnabled == false ? _enableEditingMode(recipe) : null,
    );
  }

  void _openRecipeView(Recipe recipe, Object heroTag) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecipeView(recipe, heroTag: heroTag)),
    );
  }

  void _addRecipeToEditingList(Recipe recipe) {
    if (!_selectedRecipes.contains(recipe)) {
      setState(() {
        _selectedRecipes.add(recipe);
      });
    } else {
      setState(() {
        _selectedRecipes.removeWhere((r) => r.id == recipe.id);
      });

      if (_selectedRecipes.isEmpty) {
        setState(() => _editingModeEnabled = false);
      }
    }
  }

  void _enableEditingMode(Recipe recipe) {
    setState(() => _editingModeEnabled = true);
    _addRecipeToEditingList(recipe);
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: _searchModeEnabled == false
          ? buildAppBarTitle()
          : TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search...',
              ),
              onChanged: (text) => setState(() => _searchText = text),
            ),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
          color: Colors.black,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: <Widget>[
        if (_searchModeEnabled == false)
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => setState(() => _searchModeEnabled = true),
          )
        else
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => setState(() {
              _searchModeEnabled = false;
              _searchText = "";
            }),
          ),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: _openOrderingDialog,
        )
      ],
    );
  }

  Widget buildAppBarTitle() {
    return Row(
      children: [
        Text('Recipes'),
      ],
    );
  }

  void _openOrderingDialog() async {}

  AppBar _buildEditingAppBar(WidgetRef ref) {
    return AppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() => _editingModeEnabled = false);
              _selectedRecipes.clear();
            },
          ),
          Text(
            "${_selectedRecipes.length}",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _deleteRecipes(ref),
        )
      ],
    );
  }

  void _deleteRecipes(WidgetRef ref) async {
    var confirmDelete = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Text(
                'Are you sure to delete ${_selectedRecipes.length} recipes? This operation is not reversible'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('CANCEL')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('YES')),
            ],
          );
        });

    if (confirmDelete ?? false) {
      for (var recipe in _selectedRecipes) {
        try {
          await ref.read(recipesRepositoryProvider).delete(recipe);
        } catch (e) {
          showAlertErrorMessage(context);
          return;
        }
      }
    }

    setState(() => _editingModeEnabled = false);
  }

  void _showRecipeNameDialog(WidgetRef ref) async {
    final textController = TextEditingController();
    final newRecipe = await showDialog<Recipe>(
      context: context,
      builder: (_) => AlertDialog(
        content: TextField(
          autofocus: true,
          controller: textController,
          decoration: InputDecoration(hintText: 'Recipe name'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'CANCEL',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text(
              'CREATE',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              if (textController.text.trim().isNotEmpty) {
                await ref.read(recipesRepositoryProvider).save(
                    Recipe(id: ObjectId().hexString, name: textController.text),
                    params: {UPDATE_PARAM: false});
              } else {
                print("No name supplied");
              }
            },
          )
        ],
      ),
    );

    if (newRecipe != null) {
      _openNewRecipeScreen(newRecipe);
    }
  }

  void _openNewRecipeScreen(Recipe newRecipe) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeView(newRecipe),
      ),
    );
  }
}
