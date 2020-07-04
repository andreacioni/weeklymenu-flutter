import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/providers/menus_provider.dart';
import '../../globals/errors_handlers.dart';
import '../../globals/constants.dart' as constants;
import '../../models/menu.dart';
import './scroll_view.dart';

class MenuEditorScreen extends StatefulWidget {
  MenuEditorScreen();

  @override
  _MenuEditorScreenState createState() => _MenuEditorScreenState();
}

class _MenuEditorScreenState extends State<MenuEditorScreen> {
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
        ? constants.pastColor
        : (dailyMenu.isToday
            ? constants.todayColor
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
            if (!_editingMode)
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => setState(() => _editingMode = true),
              )
            else ...<Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _handleDeleteRecipes(dailyMenu),
              ),
              IconButton(
                icon: Icon(Icons.swap_horiz),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.add_box),
                onPressed: () {},
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
    );
  }

  void _handleDeleteRecipes(DailyMenu dailyMenu) {
    dailyMenu.removeSelectedMealRecipes();
  }

  void _saveDailyMenu(DailyMenu dailyMenu) async {
    if (dailyMenu.isEdited) {      
      showProgressDialog(context);
      
      for (MenuOriginator menu in dailyMenu.menus) {
        if (menu.recipes.isEmpty) {
          // No recipes in menu means that there isn't a menu for that meal, so when can remove it
          try {
            await dailyMenu.removeMenu(
                Provider.of<MenusProvider>(context, listen: false), menu);
          } catch (e) {
            hideProgressDialog(context);
            showAlertErrorMessage(context);
            return;
          }
        }
      }

      try {
        await dailyMenu.save();
      } catch(e) {
        showAlertErrorMessage(context);
      }
      
      hideProgressDialog(context);
    }
    setState(() => _editingMode = false);
  }

  void _handleBackButton(DailyMenu dailyMenu) async {
    var cancel = true;
    if (_editingMode == true && dailyMenu.isEdited) {
      cancel = await showDialog<bool>(
        context: context,
        builder: (bCtx) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Every unsaved change will be lost'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(bCtx).pop(false),
              child: Text('CANCEL'),
            ),
            FlatButton(
              onPressed: () => Navigator.of(bCtx).pop(true),
              child: Text('OK'),
            )
          ],
        ),
      );
    }

    if (cancel != null && cancel == true) {
      dailyMenu.restoreOriginal();
      Navigator.of(context).pop();
    }
  }
}