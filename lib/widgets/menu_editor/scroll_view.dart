import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/providers/menus_provider.dart';
import 'package:weekly_menu_app/providers/recipes_provider.dart';
import 'package:logging/logging.dart';

import '../../globals/utils.dart' as utils;
import '../../globals/constants.dart' as constants;
import '../recipe_view/recipe_view.dart';
import '../../models/menu.dart';
import '../../models/recipe.dart';
import '../../models/enums/meals.dart';
import './recipe_tile.dart';
import './recipe_suggestion_text_field.dart';

class MenuEditorScrollView extends StatefulWidget {
  final DailyMenu _dailyMenu;
  final bool editingMode;

  MenuEditorScrollView(this._dailyMenu, {this.editingMode});

  @override
  _MenuEditorScrollViewState createState() => _MenuEditorScrollViewState();
}

class _MenuEditorScrollViewState extends State<MenuEditorScrollView> {
  final log = Logger((_MenuEditorScrollViewState).toString());

  ProgressDialog progressDialog;

  bool _initialized;
  ThemeData _theme;

  bool _dragMode;
  Meal _fromMeal;

  Meal _addRecipeMealTarget;

  @override
  void initState() {
    _addRecipeMealTarget = null;
    _initialized = false;
    _dragMode = false;
    
    Future.delayed(Duration(seconds: 0)).then(
      (_) {
        progressDialog = ProgressDialog(
          context,
          isDismissible: false,
        );
        progressDialog.style(
          message: 'Adding recipe',
          progressWidget: CircularProgressIndicator(),
        );
      },
    );
    
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initialized == false) {
      _theme = Theme.of(context).copyWith(
        splashColor: Theme.of(context).primaryColor.withOpacity(0.4),
        appBarTheme: AppBarTheme(color: Colors.grey.shade100),
      );

      _initialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _theme,
      child: CustomScrollView(
        slivers: Meal.values
            .map((m) =>
                _buildAppBarForMeal(m, widget._dailyMenu.getRecipeIdsByMeal(m)))
            .expand((element) => element)
            .toList(),
      ),
    );
  }

  List<Widget> _buildAppBarForMeal(Meal meal, List<String> recipeIds) {
    return <Widget>[
      SliverAppBar(
        pinned: true,
        forceElevated: true,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Icon(meal.icon),
            SizedBox(
              width: 10,
            ),
            Text(
              meal.value,
              textAlign: TextAlign.right,
            ),
          ],
        ),
        actions: <Widget>[
          if (widget.editingMode) ...<Widget>[
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _showRecipeTextFieldForMeal(meal),
            ),
          ]
        ],
      ),
      SliverList(
        delegate: SliverChildListDelegate.fixed(
          <Widget>[
            if (_addRecipeMealTarget == meal)
              RecipeSuggestionTextField(
                meal,
                autofocus: true,
                enabled: true,
                hintText: 'Recipe',
                showSuggestions: true,
                onFocusChanged: (hasFocus) {
                  if (hasFocus == false) {
                    _stopMealEditing(widget._dailyMenu);
                  }
                },
                onRecipeSelected: (recipe) => _addRecipeToMeal(meal, recipe),
                onSubmitted: (recipeName) => _createNewRecipeByName(meal, recipeName),
              ),
            if (recipeIds.isNotEmpty)
              ...recipeIds
                  .map((id) => _buildRecipeTile(widget._dailyMenu, meal, id))
                  .toList(),
            _buildDragTarget(meal),
          ],
        ),
      ),
    ];
  }

  void _showRecipeTextFieldForMeal(Meal meal) {
    setState(() {
      _addRecipeMealTarget = meal;
    });
  }

  void _addRecipeToMeal(Meal meal, RecipeOriginator recipe) {
    if (widget._dailyMenu.getMenuByMeal(meal) == null) {
      var newMenu =
          Menu(date: widget._dailyMenu.day, recipes: [recipe.id], meal: meal);
      widget._dailyMenu.addMenu(MenuOriginator(newMenu));
    } else {
      widget._dailyMenu.addRecipeToMeal(meal, recipe);
    }
  }

  void _createNewRecipeByName(Meal meal, String recipeName) async {
    if (recipeName != null && recipeName.trim().isNotEmpty) {
      progressDialog.show();
      RecipeOriginator recipe = await Provider.of<RecipesProvider>(context, listen: false).addRecipe(Recipe(name: recipeName));
      progressDialog.hide();
      
      _addRecipeToMeal(meal, recipe);
    } else {
      log.warning("Can't create a reicpe with empty name");
    }
  }

  void _stopMealEditing(DailyMenu dailyMenu) {
    dailyMenu.clearSelected();
    setState(() {
      _addRecipeMealTarget = null;
    });
  }

  Widget _buildRecipeTile(DailyMenu dailyMenu, Meal meal, String id) {
    final recipe = Provider.of<RecipesProvider>(context).getById(id);
    final mealRecipe = MealRecipe(meal, recipe);
    final recipeTile = RecipeTile(
      editEnable: widget.editingMode,
      isChecked: false,
      onPressed: !widget.editingMode ? () => _openRecipeView(recipe) : null,
      onCheckChange: (c) => _hadleRecipeCheckChange(dailyMenu, mealRecipe, c),
      key: ValueKey(mealRecipe.meal.toString() + '_' + mealRecipe.recipe.id),
    );
    return ChangeNotifierProvider.value(
      value: recipe,
      child: Column(
        children: <Widget>[
          if (!widget.editingMode)
            recipeTile
          else
            Draggable<MealRecipe>(
              child: recipeTile,
              feedback: Material(
                child: Text(recipe.name),
              ),
              childWhenDragging: Container(),
              data: mealRecipe,
              onDragStarted: () => setState(() {
                _dragMode = true;
                _fromMeal = meal;
              }),
              onDragCompleted: () => setState(() => _dragMode = false),
              onDragEnd: (_) => setState(() => _dragMode = false),
              onDraggableCanceled: (_, __) => setState(() => _dragMode = false),
            ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }

  DragTarget<MealRecipe> _buildDragTarget(Meal meal) {
    return DragTarget<MealRecipe>(
      builder: (bCtx, accepted, rejected) =>
          _dropTargetBuilder(bCtx, accepted, rejected, meal),
      onWillAccept: (mealRecipe) {
        print('onWillAccept - $meal');
        return true;
      },
      onAccept: (mealRecipe) {
        print('onAccept - $meal');
        if (widget._dailyMenu.getMenuByMeal(meal) == null) {
          widget._dailyMenu.addMenu(
              MenuOriginator(Menu(date: widget._dailyMenu.day, meal: meal)));
        }
        widget._dailyMenu
            .moveRecipeToMeal(mealRecipe.meal, meal, mealRecipe.recipe.id);
      },
      onLeave: (_) {
        print('onLeave - $meal');
      },
    );
  }

  void _hadleRecipeCheckChange(
      DailyMenu dailyMenu, MealRecipe mealRecipe, bool checked) {
    if (checked) {
      dailyMenu.setSelectedRecipe(mealRecipe);
    } else {
      dailyMenu.removeSelectedRecipe(mealRecipe);
    }
  }

  Widget _dropTargetBuilder(BuildContext context,
      List<MealRecipe> candidateRecipes, rejectedRecipes, Meal targetMeal) {
    if (candidateRecipes.isNotEmpty) {
      return ListTile(title: Text(candidateRecipes[0].recipe.name));
    } else if (_dragMode == true && _fromMeal != targetMeal) {
      return Center(
        child: Text('DROP HERE'),
      );
    } else {
      return Container();
    }
  }

  void _openRecipeView(RecipeOriginator recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
            value: recipe,
            child: RecipeView(
              heroTag: Object(), //Just a placeholder to avoid NPE
            )),
      ),
    );
  }
}
