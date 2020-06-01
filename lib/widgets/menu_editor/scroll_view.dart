import 'package:flutter/material.dart';

import '../../globals/utils.dart' as utils;
import '../../globals/constants.dart' as constants;
import '../../models/menu.dart';
import '../../models/enums/meals.dart';

class MenuEditorScrollView extends StatefulWidget {
  final DailyMenu _dailyMenu;

  MenuEditorScrollView(this._dailyMenu);

  @override
  _MenuEditorScrollViewState createState() => _MenuEditorScrollViewState();
}

class _MenuEditorScrollViewState extends State<MenuEditorScrollView> {
  bool _initialized;

  ThemeData _theme;

  @override
  void initState() {
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
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _theme,
      child: CustomScrollView(
        slivers: <Widget>[
          _buildAppBarForMeal(Meal.Breakfast),
          _buildAppBarForMeal(Meal.Lunch),
          _buildAppBarForMeal(Meal.Dinner),
        ],
      ),
    );
  }

  Widget _buildAppBarForMeal(Meal meal) {
    return SliverAppBar(
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
          icon: Icon(Icons.delete),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {},
        ),
      ],
    );
  }
}
