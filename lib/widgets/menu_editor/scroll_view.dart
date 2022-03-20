import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectid/objectid.dart';

import '../../globals/errors_handlers.dart';
import '../../models/enums/meal.dart';
import '../recipe_view/screen.dart';
import '../../models/menu.dart';
import '../../models/recipe.dart';
import './recipe_tile.dart';
import './recipe_suggestion_text_field.dart';

class MenuEditorScrollView extends StatefulWidget {
  final DailyMenu _dailyMenu;
  final bool editingMode;

  MenuEditorScrollView(this._dailyMenu, {this.editingMode = false});

  @override
  _MenuEditorScrollViewState createState() => _MenuEditorScrollViewState();
}

class _MenuEditorScrollViewState extends State<MenuEditorScrollView> {
  final _log = Logger();

  late bool _initialized;
  late ThemeData _theme;

  late bool _dragMode;
  Meal? _fromMeal;

  Meal? _addRecipeMealTarget;

  @override
  void initState() {
    _addRecipeMealTarget = null;
    _initialized = false;
    _dragMode = false;

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
    return HookConsumer(builder: (context, ref, _) {
      final recipeRepository = ref.read(recipesRepositoryProvider);
      final menuRepository = ref.read(menusRepositoryProvider);

      return Theme(
        data: _theme,
        child: CustomScrollView(
          slivers: Meal.values
              .map((m) => _buildSliversForMeal(
                  m,
                  widget._dailyMenu.getMenuByMeal(m),
                  recipeRepository,
                  menuRepository))
              .expand((element) => element)
              .toList(),
        ),
      );
    });
  }

  /**
  * We can't pass only the menu object because it could be null if there isn't any recipe defined
  * for that (day, meal)
  **/
  List<Widget> _buildSliversForMeal(Meal meal, MenuOriginator? menu,
      Repository<Recipe> recipeRepository, Repository<Menu> menuRepository) {
    assert(meal.value != null);

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
              meal.value!,
              textAlign: TextAlign.right,
            ),
          ],
        ),
        actions: <Widget>[
          if (widget.editingMode) ...<Widget>[
/*             IconButton(
              icon: Icon(Icons.swap_horiz),
              onPressed: menu != null &&
                      menu.recipes != null &&
                      menu.recipes.isNotEmpty
                  ? () => _swapMenuBetweenDays(menu)
                  : null,
            ), */
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
                dailyMenu: widget._dailyMenu,
                autofocus: true,
                enabled: true,
                hintText: 'Recipe',
                showSuggestions: true,
                onFocusChanged: (hasFocus) {
                  if (hasFocus == false) {
                    _stopMealEditing(widget._dailyMenu);
                  }
                },
                onRecipeSelected: (recipe) =>
                    _handleAddRecipe(meal, recipe, menuRepository),
                onSubmitted: (recipeName) => _createNewRecipeByName(
                    meal, recipeName, recipeRepository, menuRepository),
              ),
            if (menu != null && menu.recipes.isNotEmpty)
              ...menu.recipes
                  .map((id) => _buildRecipeTile(
                      widget._dailyMenu, meal, id, recipeRepository))
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

  void _handleAddRecipe(
      Meal meal, Recipe recipe, Repository<Menu> menuRepository) async {
    showProgressDialog(context);
    try {
      await _addRecipeToMeal(meal, recipe, menuRepository);
      hideProgressDialog(context);
    } catch (e) {
      hideProgressDialog(context);
      showAlertErrorMessage(context);
    }
  }

  Future<void> _addRecipeToMeal(
      Meal meal, Recipe recipe, Repository<Menu> menuRepository) async {
    if (widget._dailyMenu.getMenuByMeal(meal) == null) {
      await menuRepository.save(
        Menu(
          id: ObjectId().hexString,
          date: widget._dailyMenu.day,
          recipes: [],
          meal: meal,
        ),
      );
      widget._dailyMenu.addRecipeToMeal(meal, recipe);
    } else {
      widget._dailyMenu.addRecipeToMeal(meal, recipe);
    }
  }

  void _createNewRecipeByName(
      Meal meal,
      String recipeName,
      Repository<Recipe> recipeRepository,
      Repository<Menu> menuRepository) async {
    if (recipeName != null && recipeName.trim().isNotEmpty) {
      showProgressDialog(context);

      try {
        Recipe recipe = await recipeRepository
            .save(Recipe(id: ObjectId().hexString, name: recipeName));
        await _addRecipeToMeal(meal, recipe, menuRepository);
      } catch (e) {
        hideProgressDialog(context);
        showAlertErrorMessage(context);
        return;
      }

      hideProgressDialog(context);
    } else {
      _log.w("Can't create a reicpe with empty name");
    }
  }

  void _stopMealEditing(DailyMenu dailyMenu) {
    setState(() => _addRecipeMealTarget = null);
  }

  Widget _buildRecipeTile(DailyMenu dailyMenu, Meal meal, String id,
      Repository<Recipe> recipeRepository) {
    return FutureBuilder<Recipe?>(
        future: recipeRepository.findOne(id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error occurred');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return Text('Recipe not found!');
          }

          final recipe = snapshot.data!;

          final mealRecipe = MealRecipe(meal, recipe);
          final recipeTile = RecipeTile(
            recipe,
            editEnable: widget.editingMode,
            isChecked: dailyMenu.selectedRecipes.contains(id),
            onPressed:
                !widget.editingMode ? () => _openRecipeView(recipe) : null,
            onCheckChange: (c) =>
                _handleRecipeCheckChange(dailyMenu, mealRecipe, c ?? false),
            key: ValueKey(
                mealRecipe.meal.toString() + '_' + mealRecipe.recipe.id),
          );

          return Column(
            //key: ,
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
                  onDraggableCanceled: (_, __) =>
                      setState(() => _dragMode = false),
                ),
              Divider(
                height: 0,
              ),
            ],
          );
        });
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
          widget._dailyMenu.addMenu(MenuOriginator(Menu(
              id: ObjectId().hexString,
              date: widget._dailyMenu.day,
              meal: meal)));
        }
        widget._dailyMenu
            .moveRecipeToMeal(mealRecipe.meal, meal, mealRecipe.recipe.id);
      },
      onLeave: (_) {
        print('onLeave - $meal');
      },
    );
  }

  void _handleRecipeCheckChange(
      DailyMenu dailyMenu, MealRecipe mealRecipe, bool checked) {
    if (checked) {
      dailyMenu.setSelectedRecipe(mealRecipe);
    } else {
      dailyMenu.removeSelectedRecipe(mealRecipe);
    }
  }

  Widget _dropTargetBuilder(BuildContext context,
      List<MealRecipe?> candidateRecipes, rejectedRecipes, Meal targetMeal) {
    candidateRecipes.removeWhere((e) => e == null);

    if (candidateRecipes.isNotEmpty) {
      return ListTile(title: Text(candidateRecipes[0]!.recipe.name));
    } else if (_dragMode == true && _fromMeal != targetMeal) {
      return Center(
        child: Text('DROP HERE'),
      );
    } else {
      return Container();
    }
  }

  void _openRecipeView(Recipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeView(recipe),
      ),
    );
  }
}
