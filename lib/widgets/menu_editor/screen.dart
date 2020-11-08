import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/globals/date.dart';
import 'package:weekly_menu_app/models/enums/meals.dart';
import 'package:weekly_menu_app/globals/constants.dart' as consts;
import '../../globals/errors_handlers.dart';
import '../../models/menu.dart';
import './scroll_view.dart';

class MenuEditorScreen extends StatefulWidget {
  MenuEditorScreen({Key key}) : super(key: key);

  @override
  _MenuEditorScreenState createState() => _MenuEditorScreenState();
}

class _MenuEditorScreenState extends State<MenuEditorScreen> {
  final _log = Logger();

  static final _dateParser = DateFormat('EEEE, MMMM dd');

  bool _editingMode;

  /**
   * Used when moving recipes between days
   */
  Menu _newMenu;
  DailyMenu _destinationMenu;

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
            title: Text(dailyMenu.day.format(_dateParser)),
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
                  icon: Icon(Icons.swap_horiz),
                  onPressed: dailyMenu.hasSelectedRecipes
                      ? () => _handleSwapRecipes(dailyMenu)
                      : null,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: dailyMenu.hasSelectedRecipes
                      ? () => _handleDeleteRecipes(dailyMenu)
                      : null,
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
    if (dailyMenu.isEdited ||
        _newMenu != null ||
        (_destinationMenu != null && _destinationMenu.isEdited)) {
      _log.i("Saving all daily menu changes");
      showProgressDialog(context);

      if (dailyMenu.isEdited) {
        try {
          await dailyMenu.save(
            context,
            Provider.of<Repository<Menu>>(context, listen: false),
          );
        } catch (e) {
          _log.e("Error saving currently menu", e);
          return;
        }
      }

      if (_newMenu != null) {
        _log.d("New menu was defined. Store it!");
        try {
          await Provider.of<Repository<Menu>>(context, listen: false)
              .save(_newMenu);
        } catch (e) {
          _log.e("Error saving new menu", e);
          hideProgressDialog(context);
          showAlertErrorMessage(context);
          return;
        }
        _newMenu = null;
      }

      if (_destinationMenu != null && _destinationMenu.isEdited) {
        _log.d("Already existing menu was modified. Save it!");
        try {
          _destinationMenu.save(
            context,
            Provider.of<Repository<Menu>>(context, listen: false),
          );
        } catch (e) {
          _log.e("Error saving destination menu ", e);
          hideProgressDialog(context);
          showAlertErrorMessage(context);
          return;
        }
        _destinationMenu = null;
      }

      hideProgressDialog(context);
    }

    dailyMenu.clearSelected();

    setState(() => _editingMode = false);
  }

  void _handleBackButton(DailyMenu dailyMenu) async {
    if (dailyMenu.isEdited ||
        _newMenu != null ||
        (_destinationMenu != null && _destinationMenu.isEdited)) {
      final wannaSave = await showWannaSaveDialog(context);

      if (wannaSave) {
        _saveDailyMenu(dailyMenu);
      } else {
        _log.i("Losing all the changes");

        if (dailyMenu.isEdited) {
          dailyMenu.revert();
        }

        if (_newMenu != null) {
          _newMenu = null;
        }

        if (_destinationMenu != null && _destinationMenu.isEdited) {
          _destinationMenu.revert();
          _destinationMenu = null;
        }
      }
    } else {
      _log.d("No changes made, not save action is necessary");
    }

    dailyMenu.clearSelected();

    Navigator.of(context).pop();
  }

  void _handleSwapRecipes(DailyMenu dailyMenu, {bool cut = true}) async {
    //Ask for destination day
    final destinationDay = Date(
      await showDatePicker(
        context: context,
        initialDate: dailyMenu.day.toDateTime,
        firstDate: Date.now()
            .subtract(Duration(days: (consts.pageViewLimitDays / 2).truncate()))
            .toDateTime,
        lastDate: Date.now()
            .add((Duration(days: (consts.pageViewLimitDays / 2).truncate())))
            .toDateTime,
      ),
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
    final menuRepository =
        Provider.of<Repository<Menu>>(context, listen: false);
    //_destinationMenu =
    //    await menuRepository.findAll(param: {'day': destinationDay}); //TODO fix me

    /* 
      Ask action to be performed if there are recipes already 
      defined in selected (day, meal), otherwise just move (and create
      menu if not defined)
    */
    if (_destinationMenu == null ||
        _destinationMenu.menus == null ||
        _destinationMenu.menus.isEmpty) {
      _log.i("No menus in destination day, creating menu");
      _newMenu = Menu(
        meal: destinationMeal,
        date: destinationDay,
        recipes: dailyMenu.selectedRecipes,
      );
    } else {
      //Check if all selected recipes are in the same meal
      final sameMeal = dailyMenu.selectedRecipesMeal;
      final alreadyDefinedMenu =
          _destinationMenu.getMenuByMeal(destinationMeal);

      if (alreadyDefinedMenu == null) {
        _log.i("Destination menu is not already defined, creating menu");
        _newMenu = Menu(
          meal: destinationMeal,
          date: destinationDay,
          recipes: dailyMenu.selectedRecipes,
        );
      } else if (alreadyDefinedMenu.isEmpty) {
        _log.i("Destination menu is defined but empty, add new recipes to it");
        alreadyDefinedMenu.addRecipesByIdList(dailyMenu.selectedRecipes);
      } else {
        /**
         * If sameMeal == null it means that selected recipes in current menu
         * belong to more meals and so it's impossible to ask for move/swap. Instead
         * we can ask for merge/overwrite current selected recipes in destination menu 
         * */
        if (sameMeal == null) {
          final mergeRecipes = await showDialog<bool>(
            context: context,
            child: AlertDialog(
              title: Text("Overwrite or Merge?"),
              content: Text(
                  "There are alredy defined recipes for that meal. Would you merge or overwrite them?"),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("MERGE")),
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("OVERWRITE"))
              ],
            ),
          );

          if (!mergeRecipes) {
            _log.i("Overwriting recipes");
            _destinationMenu.removeAllRecipesFromMeal(destinationMeal);
          }
          _destinationMenu.addRecipeIdListToMeal(
              destinationMeal, dailyMenu.selectedRecipes);
        } else {
          _log.i(
              "Destination menu is present, do you want to swap or move recipes?");

          final swapRecipes = await showDialog<bool>(
            context: context,
            child: AlertDialog(
              title: Text("Swap or Merge?"),
              content: Text(
                  "There are alredy defined recipes for that meal. Would you merge or swap them?"),
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

          if (swapRecipes) {
            _log.i("Swapping recipes");
            final destinationRecipes =
                _destinationMenu.getRecipeIdsByMeal(destinationMeal);
            dailyMenu.addRecipeIdListToMeal(sameMeal, destinationRecipes);
            _destinationMenu.removeAllRecipesFromMeal(destinationMeal);
          }
          _destinationMenu.addRecipeIdListToMeal(
              destinationMeal, dailyMenu.selectedRecipes);
        }
      }
    }
    if (cut) {
      dailyMenu.removeSelectedMealRecipes();
    }

    dailyMenu.clearSelected();
  }
}
