import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectid/objectid.dart';

import 'package:weekly_menu_app/models/date.dart';
import 'package:weekly_menu_app/globals/constants.dart' as consts;
import 'package:weekly_menu_app/services/daily_menu_service.dart';
import '../../globals/errors_handlers.dart';
import '../../models/enums/meal.dart';
import '../../models/menu.dart';
import './scroll_view.dart';

class MenuEditorScreen extends StatefulWidget {
  final DailyMenu dailyMenu;
  MenuEditorScreen(this.dailyMenu, {Key? key}) : super(key: key);

  @override
  _MenuEditorScreenState createState() => _MenuEditorScreenState();
}

class _MenuEditorScreenState extends State<MenuEditorScreen> {
  final _log = Logger();

  static final _dateParser = DateFormat('EEEE, MMMM dd');

  late bool _editingMode;

  /**
   * Used when moving recipes between days
   */
  Menu? _newMenu;
  DailyMenu? _destinationMenu;

  @override
  void initState() {
    _editingMode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dailyMenu = widget.dailyMenu;

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
    return HookConsumer(builder: (context, ref, _) {
      final dailyMenuService = ref.read(dailyMenuServiceProvider);
      final menuRepository = ref.read(menusRepositoryProvider);

      return Theme(
        data: theme,
        child: WillPopScope(
          onWillPop: () async {
            _handleBackButton(dailyMenu, menuRepository, dailyMenuService);
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => _handleBackButton(
                    dailyMenu, menuRepository, dailyMenuService),
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
                        ? () => _handleSwapRecipes(dailyMenu, menuRepository)
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
                    onPressed: () => _saveDailyMenu(
                        dailyMenu, menuRepository, dailyMenuService),
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
    });
  }

  void _handleDeleteRecipes(DailyMenu dailyMenu) {
    dailyMenu.removeSelectedMealRecipes();
  }

  Future<void> _saveDailyMenu(
      DailyMenu dailyMenu,
      Repository<Menu> menuRepository,
      DailyMenuService dailyMenuService) async {
    if (dailyMenu.isEdited ||
        _newMenu != null ||
        (_destinationMenu != null && _destinationMenu!.isEdited)) {
      _log.i("Saving all daily menu changes");
      showProgressDialog(context);

      if (dailyMenu.isEdited) {
        try {
          await dailyMenuService.save(dailyMenu);
        } catch (e) {
          _log.e("Error saving currently menu", e);
          return;
        }
      }

      if (_newMenu != null) {
        _log.d("New menu was defined. Store it!");
        try {
          await menuRepository.save(_newMenu!);
        } catch (e) {
          _log.e("Error saving new menu", e);
          hideProgressDialog(context);
          showAlertErrorMessage(context);
          return;
        }
        _newMenu = null;
      }

      if (_destinationMenu != null && _destinationMenu!.isEdited) {
        _log.d("Already existing menu was modified. Save it!");
        try {
          dailyMenuService.save(_destinationMenu!);
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

  void _handleBackButton(DailyMenu dailyMenu, Repository<Menu> menuRepository,
      DailyMenuService dailyMenuService) async {
    if (dailyMenu.isEdited ||
        _newMenu != null ||
        (_destinationMenu != null && _destinationMenu!.isEdited)) {
      final wannaSave = await showWannaSaveDialog(context);

      if (wannaSave ?? false) {
        _saveDailyMenu(dailyMenu, menuRepository, dailyMenuService);
      } else {
        _log.i("Losing all the changes");

        if (dailyMenu.isEdited) {
          dailyMenu.revert();
        }

        if (_newMenu != null) {
          _newMenu = null;
        }

        if (_destinationMenu != null && _destinationMenu!.isEdited) {
          _destinationMenu!.revert();
          _destinationMenu = null;
        }
      }
    } else {
      _log.d("No changes made, not save action is necessary");
    }

    dailyMenu.clearSelected();

    Navigator.of(context).pop();
  }

  void _handleSwapRecipes(DailyMenu dailyMenu, Repository<Menu> menuRepository,
      {bool cut = true}) async {
    //Ask for destination day
    final destinationDateTime = await showDatePicker(
      context: context,
      initialDate: dailyMenu.day.toDateTime,
      firstDate: Date.now()
          .subtract(Duration(days: (consts.pageViewLimitDays / 2).truncate()))
          .toDateTime,
      lastDate: Date.now()
          .add((Duration(days: (consts.pageViewLimitDays / 2).truncate())))
          .toDateTime,
    );

    if (destinationDateTime == null) {
      return;
    }

    final destinationDay = Date(destinationDateTime);

    //Ask for destination meal
    final destinationMeal = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
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
    //final menuRepository = context.read(menusRepositoryProvider);
    //_destinationMenu =
    //    await menuRepository.findAll(param: {'day': destinationDay}); //TODO fix me

    /* 
      Ask action to be performed if there are recipes already 
      defined in selected (day, meal), otherwise just move (and create
      menu if not defined)
    */
    if (_destinationMenu?.menus.isEmpty ?? true) {
      _log.i("No menus in destination day, creating menu");
      _newMenu = Menu(
        id: ObjectId().hexString,
        meal: destinationMeal,
        date: destinationDay,
        recipes: dailyMenu.selectedRecipes,
      );
    } else {
      //Check if all selected recipes are in the same meal
      final sameMeal = dailyMenu.selectedRecipesMeal;
      final alreadyDefinedMenu =
          _destinationMenu!.getMenuByMeal(destinationMeal);

      if (alreadyDefinedMenu == null) {
        _log.i("Destination menu is not already defined, creating menu");
        _newMenu = Menu(
          id: ObjectId().hexString,
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
            builder: (context) => AlertDialog(
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

          if (!(mergeRecipes ?? false)) {
            _log.i("Overwriting recipes");
            _destinationMenu!.removeAllRecipesFromMeal(destinationMeal);
          }
          _destinationMenu!.addRecipeIdListToMeal(
              destinationMeal, dailyMenu.selectedRecipes);
        } else {
          _log.i(
              "Destination menu is present, do you want to swap or move recipes?");

          final swapRecipes = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
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

          if (swapRecipes ?? false) {
            _log.i("Swapping recipes");
            final destinationRecipes =
                _destinationMenu!.getRecipeIdsByMeal(destinationMeal);
            dailyMenu.addRecipeIdListToMeal(sameMeal, destinationRecipes);
            _destinationMenu!.removeAllRecipesFromMeal(destinationMeal);
          }
          _destinationMenu!.addRecipeIdListToMeal(
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
