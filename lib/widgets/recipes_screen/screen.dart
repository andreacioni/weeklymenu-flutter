import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_data_state/flutter_data_state.dart';
import 'package:weekly_menu_app/models/ingredient.dart';

import '../../globals/errors_handlers.dart';
import '../recipe_view/screen.dart';
import '../../globals/utils.dart';
import '../../models/recipe.dart';
import './recipe_card.dart';
import '../../presentation/custom_icons_icons.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final _log = Logger();

  bool _searchModeEnabled;
  String _searchText;

  bool _editingModeEnabled;
  List<Recipe> _selectedRecipes;

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
    final repository = context.watch<Repository<Recipe>>();

    return Scaffold(
      appBar: _editingModeEnabled == false
          ? _buildAppBar(context)
          : _buildEditingAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRecipeNameDialog,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: buildDataStateBuilder(repository),
    );
  }

  DataStateBuilder<List<Recipe>> buildDataStateBuilder(
      Repository<Recipe> repository) {
    return DataStateBuilder<List<Recipe>>(
      notifier: () => repository.watchAll(),
      builder: (context, state, notifier, _) {
        if (state.isLoading && !state.hasModel) {
          return Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: _buildScreenBody(
              state.model,
              filter: (recipe) => !stringContains(recipe.name, _searchText),
            ),
          ),
          onRefresh: () => notifier.reload(),
        );
      },
    );
  }

  Widget _buildScreenBody(List<Recipe> recipes,
      {bool Function(Recipe) filter}) {
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
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (ctx, index) => Hero(
        tag: recipes[index].id,
        child: ChangeNotifierProvider.value(
          value: recipes[index],
          child: RecipeCard(
            borderSide: _editingModeEnabled == true &&
                    _selectedRecipes.contains(recipes[index])
                ? BorderSide(color: Theme.of(ctx).accentColor, width: 2)
                : BorderSide.none,
            shadowColorStart: _editingModeEnabled == true &&
                    _selectedRecipes.contains(recipes[index])
                ? Theme.of(ctx).accentColor.withOpacity(0.7)
                : Colors.black54,
            onTap: () => _editingModeEnabled == true
                ? _addRecipeToEditingList(recipes[index])
                : _openRecipeView(recipes, index, recipes[index].id),
            onLongPress: () => _editingModeEnabled == false
                ? _enableEditingMode(recipes[index])
                : null,
          ),
        ),
      ),
      itemCount: recipes.length,
    );
  }

  void _openRecipeView(List<Recipe> recipes, int index, Object heroTag) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeView(recipes[index].id, heroTag: heroTag),
      ),
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
    if (_searchModeEnabled) {
      _searchText = "";
    }

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
            onPressed: () => setState(() => _searchModeEnabled = false),
          ),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: _openOrderingDialog,
        )
      ],
    );
  }

  Widget buildAppBarTitle() {
    return OfflineBuilder(
      connectivityBuilder: (_, connectivity, __) {
        final bool connected = connectivity != ConnectivityResult.none;
        return Row(
          children: [
            Text('Recipes'),
            if (!connected) ...[
              SizedBox(
                width: 10,
              ),
              Icon(Icons.cloud_off)
            ],
          ],
        );
      },
      child: Container(),
    );
  }

  void _openOrderingDialog() async {}

  AppBar _buildEditingAppBar(BuildContext context) {
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
          onPressed: _deleteRecipes,
        )
      ],
    );
  }

  void _deleteRecipes() async {
    var confirmDelete = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Text(
                'Are you sure to delete ${_selectedRecipes.length} recipes? This operation is not reversible'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('NO')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('YES')),
            ],
          );
        });

    if (confirmDelete) {
      showProgressDialog(context);
      for (var recipe in _selectedRecipes) {
        try {
          await Provider.of<Repository<Recipe>>(context, listen: false)
              .delete(recipe);
        } catch (e) {
          hideProgressDialog(context);
          showAlertErrorMessage(context);
          return;
        }
      }
      hideProgressDialog(context);
    }

    setState(() => _editingModeEnabled = false);
  }

  void _showRecipeNameDialog() async {
    final textController = TextEditingController();
    RecipeOriginator newRecipe = await showDialog<RecipeOriginator>(
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
                await Provider.of<Repository<Recipe>>(context, listen: false)
                    .save(Recipe(name: textController.text));
              } else {
                _log.w("No name supplied");
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

  void _openNewRecipeScreen(RecipeOriginator newRecipe) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeView(newRecipe.id),
      ),
    );
  }
}
