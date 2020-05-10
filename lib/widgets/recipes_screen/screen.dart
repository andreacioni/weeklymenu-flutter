import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/widgets/recipe_view/recipe_view.dart';

import '../../globals/utils.dart';
import '../../providers/recipes_provider.dart';
import '../app_bar.dart';
import '../../models/recipe.dart';
import '../menu_page/recipe_title.dart';
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

  @override
  void initState() {
    _searchModeEnabled = false;
    _searchText = "";
    _isLoading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<RecipesProvider>(context).getRecipes;

    recipes.removeWhere((recipe) => !stringContains(recipe.name, _searchText));

    var body = _buildScreenBody(recipes);

    return Scaffold(
      appBar: _buildAppBar(context),
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

  Widget _buildScreenBody(List<Recipe> recipes) {
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

  Widget _buildRecipeList(List<Recipe> recipes) {
    return ListView.builder(
      itemBuilder: (_, index) => RecipeTile(recipes[index]),
      itemCount: recipes.length,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    if (_searchModeEnabled) {
      _searchText = "";
    }

    return BaseAppBar(
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
        _searchModeEnabled == false
            ? IconButton(
                icon: Icon(Icons.search),
                onPressed: () => setState(() => _searchModeEnabled = true),
              )
            : IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => setState(() => _searchModeEnabled = false),
              ),
      ],
    );
  }

  void _showRecipeNameDialog() async {
    final textController = TextEditingController();
    Recipe newRecipe = await showDialog<Recipe>(
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

  void _openNewRecipeScreen(Recipe newRecipe) {
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
