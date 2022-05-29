import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:objectid/objectid.dart';
import 'package:weekly_menu_app/globals/hooks.dart';
import 'package:weekly_menu_app/widgets/menu_editor/screen.dart';

import '../../globals/errors_handlers.dart';
import '../../models/enums/meal.dart';
import '../recipe_view/screen.dart';
import '../../models/menu.dart';
import '../../models/recipe.dart';
import './recipe_tile.dart';
import './recipe_suggestion_text_field.dart';

class MenuEditorScrollView extends StatefulHookConsumerWidget {
  final DailyMenuNotifier _dailyMenuNotifier;

  MenuEditorScrollView(this._dailyMenuNotifier);

  @override
  _MenuEditorScrollViewState createState() => _MenuEditorScrollViewState();
}

class _MenuEditorScrollViewState extends ConsumerState<MenuEditorScrollView> {
  late bool _initialized;
  late ThemeData _theme;

  Meal? _fromMeal;

  Meal? _addRecipeMealTarget;

  @override
  void initState() {
    _addRecipeMealTarget = null;
    _initialized = false;

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
    final recipeRepository = ref.watch(recipesRepositoryProvider);
    final menuRepository = ref.watch(menusRepositoryProvider);

    final dailyMenu = useStateNotifier(widget._dailyMenuNotifier);

    final selectionMode = ref.watch(menuRecipeSelectionProvider).isNotEmpty;

    void _showRecipeTextFieldForMeal(Meal meal) {
      setState(() {
        _addRecipeMealTarget = meal;
      });
    }

    Widget _dropTargetBuilder() {
      return Container();
    }

    Future<void> _addRecipeToMeal(
        Meal meal, Recipe recipe, Repository<Menu> menuRepository) async {
      if (dailyMenu.getMenuByMeal(meal) == null) {
        final menu = Menu(
          date: dailyMenu.day,
          recipes: [recipe.id],
          meal: meal,
        ).init(ref.read);
        await widget._dailyMenuNotifier.addMenu(menu);
      } else {
        await widget._dailyMenuNotifier.addRecipeToMeal(meal, recipe);
      }
    }

    void _createNewRecipeByName(
        Meal meal,
        String recipeName,
        Repository<Recipe> recipeRepository,
        Repository<Menu> menuRepository) async {
      if (recipeName.trim().isNotEmpty) {
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
        print("Can't create a reicpe with empty name");
      }
    }

    void _stopMealEditing(DailyMenu dailyMenu) {
      setState(() => _addRecipeMealTarget = null);
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

    Widget _buildRecipeTile(DailyMenu dailyMenu, Meal meal, String id,
        Repository<Recipe> recipeRepository) {
      return FutureBuilder<Recipe?>(
          future: recipeRepository.findOne(id, remote: false),
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

            return Column(
              //key: ,
              children: <Widget>[
                DraggableRecipeTile(
                  mealRecipe,
                  key: ValueKey(
                      mealRecipe.meal.toString() + '_' + mealRecipe.recipe.id),
                ),
                Divider(
                  height: 0,
                ),
              ],
            );
          });
    }

    DragTarget<Map<Meal, List<String>>> _buildDragTarget(Meal destinationMeal) {
      return DragTarget<Map<Meal, List<String>>>(
        onAccept: (mealRecipeMap) async {
          print('onAccept - $destinationMeal');
          ref.read(menuRecipeSelectionProvider.notifier).clearSelected();

          final recipeIds = mealRecipeMap.values
              .fold<List<String>>(<String>[], (pv, e) => pv..addAll(e));

          if (recipeIds.isEmpty) return;

          if (dailyMenu.getMenuByMeal(destinationMeal) == null) {
            await widget._dailyMenuNotifier.addMenu(Menu(
                    id: ObjectId().hexString,
                    date: dailyMenu.day,
                    meal: destinationMeal,
                    recipes: recipeIds)
                .init(ref.read));

            mealRecipeMap.forEach((meal, recipes) {
              widget._dailyMenuNotifier.removeRecipesFromMeal(meal, recipes);
            });
          } else {
            mealRecipeMap.forEach((meal, recipes) {
              dailyMenu.moveRecipesToMeal(meal, destinationMeal, recipes);
            });
          }
        },
        builder: (bCtx, accepted, rejected) => _dropTargetBuilder(),
      );
    }

    /**
  * We can't pass only the menu object because it could be null if there isn't any recipe defined
  * for that (day, meal)
  **/
    List<Widget> _buildSliversForMeal(Meal meal, Menu? menu,
        Repository<Recipe> recipeRepository, Repository<Menu> menuRepository) {
      assert(meal.value != null);

      return <Widget>[
        SliverAppBar(
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
          iconTheme: Theme.of(context).iconTheme,
          pinned: true,
          forceElevated: true,
          elevation: 1,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
/*             IconButton(
              icon: Icon(Icons.swap_horiz),
              onPressed: menu != null &&
                      menu.recipes != null &&
                      menu.recipes.isNotEmpty
                  ? () => _swapMenuBetweenDays(menu)
                  : null,
            ), */
            if (!selectionMode)
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _showRecipeTextFieldForMeal(meal),
              ),
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            <Widget>[
              if (_addRecipeMealTarget == meal)
                RecipeSuggestionTextField(
                  meal,
                  dailyMenu: dailyMenu,
                  autofocus: true,
                  enabled: true,
                  hintText: 'Recipe',
                  showSuggestions: true,
                  onFocusChanged: (hasFocus) {
                    if (hasFocus == false) {
                      _stopMealEditing(dailyMenu);
                    }
                  },
                  onRecipeSelected: (recipe) =>
                      _handleAddRecipe(meal, recipe, menuRepository),
                  onSubmitted: (recipeName) => _createNewRecipeByName(
                      meal, recipeName, recipeRepository, menuRepository),
                ),
              if (menu != null && menu.recipes.isNotEmpty)
                ...menu.recipes
                    .map((id) =>
                        _buildRecipeTile(dailyMenu, meal, id, recipeRepository))
                    .toList(),
              _buildDragTarget(meal),
            ],
          ),
        ),
      ];
    }

    return Theme(
      data: _theme,
      child: CustomScrollView(
        slivers: Meal.values
            .map((m) => _buildSliversForMeal(m, dailyMenu.getMenuByMeal(m),
                recipeRepository, menuRepository))
            .expand((element) => element)
            .toList(),
      ),
    );
  }
}
