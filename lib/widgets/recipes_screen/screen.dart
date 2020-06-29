import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/widgets/recipe_view/recipe_view.dart';

import '../../globals/utils.dart';
import '../../providers/recipes_provider.dart';
import '../app_bar.dart';
import '../../models/recipe.dart';
import './recipe_card.dart';
import '../../presentation/custom_icons_icons.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  bool _searchModeEnabled;
  bool _isLoading;
  String _searchText;

  bool _editingModeEnabled;
  List<RecipeOriginator> _selectedRecipes;

  @override
  void initState() {
    _searchModeEnabled = false;
    _searchText = "";
    _isLoading = false;
    _editingModeEnabled = false;
    _selectedRecipes = <RecipeOriginator>[];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<RecipesProvider>(context).getRecipes;

    recipes.removeWhere((recipe) => !stringContains(recipe.name, _searchText));

    var body = _buildScreenBody(recipes);

    return Scaffold(
      appBar: _editingModeEnabled == false
          ? _buildAppBar(context)
          : _buildEditingAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRecipeNameDialog,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: body,
            ),
    );
  }

  Widget _buildScreenBody(List<RecipeOriginator> recipes) {
    if (recipes.isEmpty && _searchModeEnabled) {
      return _buildNoRecipesFound();
    } else {
      return _buildRecipeList(recipes);
    }
  }

  Widget _buildNoRecipesFound() {
    final _textColor = Colors.grey.shade300;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          CustomIcons.not_found_lens,
          size: 130,
          color: _textColor,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Recipe "$_searchText" not found...',
          style: TextStyle(
            fontSize: 25,
            color: _textColor,
          ),
        )
      ],
    );
  }

  Widget _buildRecipeList(List<RecipeOriginator> recipes) {
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

  void _openRecipeView(
      List<RecipeOriginator> recipes, int index, Object heroTag) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: recipes[index],
          child: RecipeView(heroTag: heroTag),
        ),
      ),
    );
  }

  void _addRecipeToEditingList(RecipeOriginator recipe) {
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

  void _enableEditingMode(RecipeOriginator recipe) {
    setState(() => _editingModeEnabled = true);
    _addRecipeToEditingList(recipe);
  }

  AppBar _buildAppBar(BuildContext context) {
    if (_searchModeEnabled) {
      _searchText = "";
    }

    return AppBar(
      title: _searchModeEnabled == false
          ? Text('Recipes')
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
          onPressed: () {},
        )
      ],
    );
  }

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
      for (var recipe in _selectedRecipes) {
        await Provider.of<RecipesProvider>(context, listen: false)
            .removeRecipe(recipe);
      }
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
              setState(() => _isLoading = true);
              if (textController.text.trim().isNotEmpty) {
                await Provider.of<RecipesProvider>(context, listen: false)
                    .addRecipe(Recipe(name: textController.text));
                setState(() => _isLoading = false);
              }
              setState(() => _isLoading = false);
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
        builder: (_) => ChangeNotifierProvider.value(
          value: newRecipe,
          child: RecipeView(),
        ),
      ),
    );
  }
}
