import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/providers/recipes_provider.dart';

import '../../globals/utils.dart' as utils;
import '../../globals/constants.dart' as constants;
import '../../models/menu.dart';
import '../../models/recipe.dart';
import '../../models/enums/meals.dart';
import './recipe_tile.dart';

class MenuEditorScrollView extends StatefulWidget {
  final DailyMenu _dailyMenu;
  final bool editingMode;

  MenuEditorScrollView(this._dailyMenu, {this.editingMode});

  @override
  _MenuEditorScrollViewState createState() => _MenuEditorScrollViewState();
}

class _MenuEditorScrollViewState extends State<MenuEditorScrollView> {
  bool _initialized;
  ThemeData _theme;

  bool _dragMode;
  Meal _fromMeal;

  bool _editingMode;

  @override
  void initState() {
    _editingMode = widget.editingMode;
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
        title: Text(
          meal.value,
          textAlign: TextAlign.right,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      SliverList(
        delegate: SliverChildListDelegate.fixed(
          <Widget>[
            if (recipeIds.isNotEmpty)
              ...recipeIds.map((id) => _buildRecipeTile(meal, id)).toList(),
            _buildDragTarget(meal),
          ],
        ),
      ),
    ];
  }

  Widget _buildRecipeTile(Meal meal, String id) {
    final recipe = Provider.of<RecipesProvider>(context).getById(id);
    final mealRecipe = MealRecipe(meal, recipe);
    return ChangeNotifierProvider.value(
      value: recipe,
      child: Column(
        children: <Widget>[
          Draggable<MealRecipe>(
            child: RecipeTile(),
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
        widget._dailyMenu
            .moveRecipeToMeal(mealRecipe.meal, meal, mealRecipe.recipe.id);
      },
      onLeave: (_) {
        print('onLeave - $meal');
      },
    );
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
}
