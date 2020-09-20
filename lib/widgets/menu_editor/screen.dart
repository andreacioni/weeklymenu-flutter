import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/models/enums/meals.dart';
import 'package:weekly_menu_app/providers/menus_provider.dart';
import 'package:weekly_menu_app/globals/constants.dart' as consts;
import '../../globals/errors_handlers.dart';
import '../../models/menu.dart';
import './scroll_view.dart';

class MenuEditorScreen extends StatefulWidget {
  MenuEditorScreen();

  @override
  _MenuEditorScreenState createState() => _MenuEditorScreenState();
}

class _MenuEditorScreenState extends State<MenuEditorScreen> {
  final _log = Logger();

  static final _dateParser = DateFormat('EEEE, MMMM dd');

  bool _editingMode;

  @override
  void initState() {
    _editingMode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dailyMenu = Provider.of<DailyMenu>(context);

    final primaryColor = dailyMenu.isPast
        ? consts.pastColor
        : (dailyMenu.isToday
            ? consts.todayColor
            : Theme.of(context).primaryColor);

    final theme = Theme.of(context).copyWith(
      primaryColor: primaryColor,
      toggleableActiveColor: primaryColor,
      appBarTheme: AppBarTheme(
        color: primaryColor,
      ),
      splashColor: primaryColor.withOpacity(0.4),
    );
    return Theme(
      data: theme,
      child: WillPopScope(
        onWillPop: () async {
          _handleBackButton(dailyMenu);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => _handleBackButton(dailyMenu),
            ),
            title: Text(_dateParser.format(dailyMenu.day).toString()),
            actions: <Widget>[
              if (dailyMenu.isPast)
                IconButton(
                  icon: Icon(Icons.archive),
                  onPressed: () {},
                ),
              if (!_editingMode) ...<Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => setState(() => _editingMode = true),
                ),
              ] else ...<Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _handleDeleteRecipes(dailyMenu),
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz),
                  onPressed: () => _handleSwapRecipes(dailyMenu),
                ),
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () => _saveDailyMenu(dailyMenu),
                ),
              ]
            ],
          ),
          body: Container(
            child: MenuEditorScrollView(
              dailyMenu,
              editingMode: _editingMode,
            ),
          ),
        ),
      ),
    );
  }

  void _handleDeleteRecipes(DailyMenu dailyMenu) {
    dailyMenu.removeSelectedMealRecipes();
  }

  Future<void> _saveDailyMenu(DailyMenu dailyMenu) async {
    if (dailyMenu.isEdited) {
      _log.i("Saving all daily menu changes");
      showProgressDialog(context);

      for (MenuOriginator menu in dailyMenu.menus) {
        if (menu.recipes.isEmpty) {
          // No recipes in menu means that there isn't a menu for that meal, so when can remove it
          try {
            await Provider.of<MenusProvider>(context, listen: false)
                .removeMenu(menu);
            dailyMenu.removeMenu(menu);
          } catch (e) {
            hideProgressDialog(context);
            showAlertErrorMessage(context);
            return;
          }
        } else {
          try {
            await Provider.of<MenusProvider>(context, listen: false)
                .saveMenu(menu);
          } catch (e) {
            showAlertErrorMessage(context);
          }
        }
      }

      hideProgressDialog(context);
    }
    setState(() => _editingMode = false);
  }

  void _handleBackButton(DailyMenu dailyMenu) async {
    if (dailyMenu.isEdited) {
      final wannaSave = await showWannaSaveDialog(context);

      if (wannaSave) {
        _saveDailyMenu(dailyMenu);
      } else {
        _log.i("Losing all the changes");
        dailyMenu.revert();
      }
    } else {
      _log.d("No changes made, not save action is necessary");
    }

    Navigator.of(context).pop();
  }

  void _handleSwapRecipes(DailyMenu dailyMenu) async {
    //Ask for destination day
    final destinationDay = await showDatePicker(
      context: context,
      initialDate: dailyMenu.day,
      firstDate: DateTime.now()
          .subtract(Duration(days: (consts.pageViewLimitDays / 2).truncate())),
      lastDate: DateTime.now()
          .add((Duration(days: (consts.pageViewLimitDays / 2).truncate()))),
    );

    if (destinationDay == null) {
      return;
    }

    //Ask for destination meal
    final destinationMeal = await showDialog(
      context: context,
      child: SimpleDialog(
        title: Text("Select meal"),
        children: Meal.values
            .map(
              (meal) => InkWell(
                  child: ListTile(
                    title: Text(meal.toString()),
                  ),
                  onTap: () => Navigator.of(context).pop(meal)),
            )
            .toList(),
      ),
    );

    if (destinationMeal == null) {
      return;
    }

    //Check for empty/notEmpty destination menu
    final menusProvider = Provider.of<MenusProvider>(context, listen: false);
    final destinationMenu = await menusProvider.fetchDailyMenu(destinationDay);

    /* 
      Ask action to be performed if there are recipes already 
      defined in selected (day, meal), otherwise just move (and create
      menu if not defined)
    */
    if (destinationMenu == null ||
        destinationMenu.menus == null ||
        destinationMenu.menus.isEmpty) {
      _log.i("No menus in destination day, creating menu");
      try {
        await _moveRecipesToNewMenu(
            destinationMeal, destinationDay, dailyMenu, menusProvider);
      } catch (e) {}
    } else {
      //Check if all selected recipes are in the same meal
      final sameMeal = dailyMenu.selectedRecipesMeal;
      final alreadyDefinedMenu = destinationMenu.getMenuByMeal(destinationMeal);

      if (alreadyDefinedMenu == null) {
        _log.i("Destination menu is not already defined, creating menu");
        try {
          await _moveRecipesToNewMenu(
              destinationMeal, destinationDay, dailyMenu, menusProvider);
        } catch (e) {}
      } else if (alreadyDefinedMenu.isEmpty()) {
        alreadyDefinedMenu.addRecipesByIdList(dailyMenu.selectedRecipes);
        try {
          await _moveRecipesToNewMenu(
              destinationMeal, destinationDay, dailyMenu, menusProvider,
              newMenu: alreadyDefinedMenu);
        } catch (e) {}
      } else {
        /**
         * If sameMeal == null it means that selected recipes in current menu
         * belong to more meals and so it's impossible to ask for move/swap. Instead
         * we can ask for merge/overwrite current selected recipes in destination menu 
         * */
        if (sameMeal == null) {
        } else {
          _log.i(
              "Destination menu is present, do you want to swap or move recipes?");

          final swapRecipes = await showDialog<bool>(
            context: context,
            child: AlertDialog(
              title: Text("Swap or Merge?"),
              content: Text(
                  "There are alredy defined recipes for that meal. Would you overwrite your menus or swap them?"),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("MERGE")),
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("SWAP"))
              ],
            ),
          );

          if (swapRecipes) {}
        }
      }
    }
  }

  Future<void> _moveRecipesToNewMenu(Meal destinationMeal,
      DateTime destinationDay, DailyMenu dailyMenu, MenusProvider menusProvider,
      {Menu newMenu}) async {
    showProgressDialog(context);
    if (newMenu == null) {
      newMenu = Menu(
        meal: destinationMeal,
        date: destinationDay,
        recipes: dailyMenu.selectedRecipes,
      );
    }

    try {
      await menusProvider.createMenu(newMenu);
    } catch (e) {
      _log.e("Can't create new menu", e);
      hideProgressDialog(context);
      showAlertErrorMessage(context);
      throw e;
    }

    dailyMenu.removeSelectedMealRecipes();
    hideProgressDialog(context);
    await _saveDailyMenu(dailyMenu);
  }
}
