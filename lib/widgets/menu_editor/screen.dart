import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
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

  ProgressDialog progressDialog;

  @override
  void initState() {
    _editingMode = false;
    Future.delayed(Duration(seconds: 0)).then(
      (_) {
        progressDialog = ProgressDialog(
          context,
          isDismissible: false,
        );
        progressDialog.style(
          message: 'Saving',
          progressWidget: CircularProgressIndicator(),
        );
      },
    );

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

  Future<void> _handleDeleteRecipes(DailyMenu dailyMenu) async {
    dailyMenu.removeSelectedMealRecipes();
    await dailyMenu.save();
    progressDialog.hide();
    progressDialog.hide();
  }

  void _saveDailyMenu(DailyMenu dailyMenu) async {
    if(dailyMenu.isEdited) {
      progressDialog.show();
      await dailyMenu.save();
      progressDialog.hide();
    }
    setState(() => _editingMode = false);
  }

  void _handleBackButton(DailyMenu dailyMenu) async {
    var cancel = true;
    if (_editingMode == true) {
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
