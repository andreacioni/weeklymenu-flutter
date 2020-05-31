import 'package:flutter/material.dart';


import '../../globals/utils.dart' as utils;
import '../../globals/constants.dart' as constants;
import '../../models/enums/meals.dart';

class MenuEditorScrollView extends StatefulWidget {
  final DateTime _day;

  MenuEditorScrollView(this._day);

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
          SliverAppBar(
            pinned: true,
            forceElevated: true,
            elevation: 5,
            automaticallyImplyLeading: false,
            title: Text(
              Meal.Breakfast.value,
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}
